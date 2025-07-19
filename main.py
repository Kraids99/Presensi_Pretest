import pandas as pd
import tkinter as tk
from tkinter import filedialog
from datetime import datetime

root = tk.Tk()
root.title("Auto-Presensi") 
root.withdraw()

input_path = tk.filedialog.askopenfilename(
    title="Pilih file log report pretest (CSV/Excel)",
    filetypes=[("CSV files", "*.csv"), ("Excel files", "*.xlsx *.xls")]
)

if not input_path:
    print("Tidak ada file yang dipilih. Program berhenti.")
    exit()

try:
    if input_path.endswith('.csv'):
        df = pd.read_csv(input_path)
    elif input_path.endswith(('.xls', '.xlsx')):
        df = pd.read_excel(input_path)
    else:
        print("Format file tidak didukung.")
        exit()
except Exception as e:
    print(f"Gagal membaca file: {e}")
    exit()

print("File berhasil dibaca.")

df_attempts = df[
    df["Event context"].str.contains("Pre ? test", case=False, na=False) &
    df["Event name"].str.contains("attempt started", case=False, na=False)
]

def is_ip_luar(ip):
    return not (str(ip).startswith("10.31.211"))

def catatan_ip(ip):
    if(is_ip_luar(ip)):
        return "Mengerjakan dari luar jaringan"
    else:
        return "-"

df_result = df_attempts[["Time", "IP address", "User full name"]].copy()
df_result["Status"] = "Hadir"
df_result["Catatan"] = df_result["IP address"].apply(catatan_ip)

print("Jumlah hasil presensi:", len(df_result))
print(df_result.head())

output_path = filedialog.asksaveasfilename(
    title="Simpan hasil presensi sebagai...",
    defaultextension=".xlsx",
    filetypes=[("Excel Files", "*.xlsx")],
    initialfile="Hasil_Presensi.xlsx"
)

if not output_path:
    print("Output file tidak dipilih. Program dihentikan.")
    exit()

try:
    df_result.to_excel(output_path, index=False)
    print(f"Presensi berhasil diekspor ke: {output_path}")
except Exception as e:
    print(f"Gagal menyimpan file: {e}")