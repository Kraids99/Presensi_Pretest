import tkinter as tk
from file_dialogs import select_log_file, select_pretest_file, select_save_path
from presensi import proses_presensi

def main():
    root = tk.Tk()
    root.withdraw()
    
    log_path = select_log_file()
    pretest_path = select_pretest_file()
    if not (log_path and pretest_path):
        print("Tidak ada file yang dipilih. Program berhenti.")
        return

    df_merge = proses_presensi(log_path, pretest_path)
    save_path = select_save_path()
    if not save_path:
        print("Output file tidak dipilih. Program berhenti.")
        return

    df_merge.to_excel(save_path, index=False)  # export awal
    from excel_format import format_excel
    format_excel(save_path)

if __name__ == "__main__":
    main()
