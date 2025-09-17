from tkinter import filedialog

def select_log_file():
    return filedialog.askopenfilename(
        title="Pilih file report log (CSV/Excel)",
        filetypes=[("All supported", "*.csv *.xlsx *.xls")]
    )

def select_pretest_file():
    return filedialog.askopenfilename(
        title="Pilih file report pretest (CSV/Excel)",
        filetypes=[("All supported", "*.csv *.xlsx *.xls")]
    )

def select_save_path():
    return filedialog.asksaveasfilename(
        title="Simpan hasil presensi sebagai...",
        defaultextension=".xlsx",
        filetypes=[("Excel Files", "*.xlsx")],
        initialfile="Hasil_Presensi.xlsx"
    )
