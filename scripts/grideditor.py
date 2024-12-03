import tkinter as tk
from tkinter.filedialog import askopenfilename
from level2compressed import compress, decompress, CHARACTERS

class GridEditorApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Grid Editor")
        self.root.configure(bg="#2e2e2e")  # Dark background
        
        # Selected character
        self.selected_char = tk.StringVar(value=' ')
        
        # Feedback message
        self.feedback_message = tk.StringVar(value="")

        # Timer value
        self.timer_value = tk.StringVar(value="10")  # Default timer value
        
        # Create the main grid
        self.grid = []
        self.create_grid()
        
        # Character selection via buttons
        self.create_character_selector_buttons()
        
        # Export and Compress section
        self.create_export_compress_import_section()

        # Timer input
        self.create_timer_input()
        
        # Feedback label
        self.create_feedback_label()
    
    def create_grid(self):
        self.grid_frame = tk.Frame(self.root, bg="#2e2e2e")
        self.grid_frame.grid(row=0, column=0, padx=10, pady=10)
        
        for row in range(20):
            grid_row = []
            for col in range(20):
                cell = tk.Label(
                    self.grid_frame, 
                    text=' ', 
                    borderwidth=1, 
                    relief='solid', 
                    width=4,
                    height=2,
                    bg="#3e3e3e",
                    fg="white",
                    font=("Helvetica", 14)
                )
                cell.grid(row=row, column=col, padx=0, pady=0)
                cell.bind("<Button-1>", lambda e, r=row, c=col: self.fill_cell(r, c))
                cell.bind("<Button-3>", lambda e, r=row, c=col: self.clear_cell(r, c))
                grid_row.append(cell)
            self.grid.append(grid_row)
    
    def create_character_selector_buttons(self):
        char_frame = tk.Frame(self.root, bg="#2e2e2e")
        char_frame.grid(row=0, column=1, padx=10, pady=10, sticky="n")
        
        tk.Label(
            char_frame, 
            text="Select Character:", 
            bg="#2e2e2e", 
            fg="white", 
            font=("Helvetica", 12)
        ).grid(row=0, column=0, sticky="w", pady=(0, 5))

        for idx, char in enumerate(CHARACTERS):
          button = tk.Button(
          char_frame, 
          text=char, 
          command=lambda c=char: self.select_character(c),
          width=4, 
          height=2, 
          bg="#3e3e3e", 
          fg="white", 
          font=("Helvetica", 12)
          )
          button.grid(row=1 + idx // 5, column=idx % 5, padx=0, pady=2, sticky="nsew")

    def create_timer_input(self):
        timer_frame = tk.Frame(self.root, bg="#2e2e2e")
        timer_frame.grid(row=1, column=1, padx=10, pady=5, sticky="n")
        
        tk.Label(
            timer_frame, 
            text="Set Timer (s):", 
            bg="#2e2e2e", 
            fg="white", 
            font=("Helvetica", 12)
        ).grid(row=0, column=0, sticky="w")
        
        self.timer_entry = tk.Entry(
            timer_frame, 
            textvariable=self.timer_value, 
            width=10, 
            bg="#3e3e3e", 
            fg="white", 
            font=("Helvetica", 12), 
            insertbackground="white"
        )
        self.timer_entry.grid(row=0, column=1, padx=5, sticky="w")

    def select_character(self, char):
        self.selected_char.set(char)
    
    def create_export_compress_import_section(self):
        export_compress_import_frame = tk.Frame(self.root, bg="#2e2e2e")
        export_compress_import_frame.grid(row=1, column=0, padx=10, pady=5, sticky="w")
        
        # Export section
        tk.Label(
            export_compress_import_frame, 
            text="Filename: ", 
            bg="#2e2e2e", 
            fg="white"
        ).grid(row=0, column=0, sticky="w")
        
        self.filename_entry = tk.Entry(export_compress_import_frame, width=20, bg="#3e3e3e", fg="white", insertbackground="white")
        self.filename_entry.grid(row=0, column=1, sticky="w")
        
        export_button = tk.Button(export_compress_import_frame, text="Export", command=self.export_grid, bg="#5e5e5e", fg="white")
        export_button.grid(row=0, column=2, padx=5)
        
        # Compress button
        compress_button = tk.Button(export_compress_import_frame, text="Compress", command=self.compress_grid, bg="#5e5e5e", fg="white")
        compress_button.grid(row=0, column=3, padx=5)
        
        # Import Textfile button
        import_button = tk.Button(export_compress_import_frame, text="Import Textfile", command=self.import_text, bg="#5e5e5e", fg="white")
        import_button.grid(row=0, column=4, padx=5)

        # Import Compressed Data button
        import_button = tk.Button(export_compress_import_frame, text="Import Compressed Data", command=self.import_compressed, bg="#5e5e5e", fg="white")
        import_button.grid(row=0, column=5, padx=5)
    
    def create_feedback_label(self):
        feedback_label = tk.Label(
            self.root, 
            textvariable=self.feedback_message, 
            bg="#2e2e2e", 
            fg="white", 
            wraplength=400, 
            justify="left"
        )
        feedback_label.grid(row=2, column=0, padx=10, pady=10, sticky="w")
    
    def fill_cell(self, row, col):
        char = self.selected_char.get()
        self.grid[row][col].config(text=char)
    
    def clear_cell(self, row, col):
        self.grid[row][col].config(text=' ')

    def export_grid(self):
        filename = self.filename_entry.get()
        if filename:
            self.feedback_message.set(f"Exporting grid to '{filename}'")
            # get characters from grid
            data = []
            for row in self.grid:
                data.append([cell.cget("text") for cell in row])

            # write compressed data to file
            with open(filename, "w") as f:
                for row_idx, row in enumerate(data):
                    f.write("".join(row))
                    if row_idx < len(data) - 1:
                        f.write("\n")
            self.feedback_message.set(f"Grid exported to '{filename}'")


    def compress_grid(self):
        filename = self.filename_entry.get()
        timer = int(self.timer_value.get())

        if filename:
            self.feedback_message.set(f"Exporting grid to '{filename}'")
            # get characters from grid
            data = []
            for row in self.grid:
                data.append([cell.cget("text") for cell in row])
              
            print(data)
            print(len(data))
            print(len(data[0]))
            # compress data
  
            compressed_data = compress(data, timer)

            # write compressed data to file
            with open(filename, "wb") as f:
                f.write(bytes(compressed_data))
            self.feedback_message.set(f"Grid exported to '{filename}'")

        else:
            self.feedback_message.set("Error: Please enter a filename.")

    def import_text(self):
        self.feedback_message.set("Importing grid from formatted plaintext file.")
        filename = askopenfilename()
        with open(filename, "r") as f:
            data = f.readlines()
            for i in range(len(data)):
                data[i] = list(data[i].strip("\n"))

            for row_idx, row in enumerate(data):
                for col_idx, char in enumerate(row):
                    self.grid[row_idx][col_idx].config(text=char)
    
    def import_compressed(self):
        self.feedback_message.set("Importing grid from compressed data.")
        filename = askopenfilename()
        with open(filename, "rb") as f:
            compressed_data = f.read()
            data = decompress(compressed_data)
            
        for row_idx, row in enumerate(data[0]):
            for col_idx, char in enumerate(row):
                self.grid[row_idx][col_idx].config(text=char)

        self.timer_value.set(str(data[1]))
        
if __name__ == "__main__":
    root = tk.Tk()
    app = GridEditorApp(root)
    root.mainloop()
