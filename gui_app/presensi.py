import pandas as pd

def read_file(path):
    if path.endswith('.csv'):
        return pd.read_csv(path)
    elif path.endswith(('.xls', '.xlsx')):
        return pd.read_excel(path)
    raise ValueError("Format file tidak didukung.")

def is_ip_luar(ip):
    return not str(ip).startswith("10.31.211")

def catatan_ip_list(ip_list):
    return "Mengerjakan dari luar jaringan" if any(is_ip_luar(ip) for ip in ip_list) else "-"

def pilih_ip_tampil(ip_list):
    """
    - Jika semua IP diawali '10.31.211' -> ambil IP pertama
    - Jika ada IP luar -> ambil salah satu IP luar (yang pertama ditemukan)
    """
    if not ip_list:
        return "-"
    # cek apakah ada ip luar
    for ip in ip_list:
        if is_ip_luar(ip):
            return ip  # ambil IP luar pertama
    # kalau semua internal
    return ip_list[0]

def proses_presensi(log_path, pretest_path):
    df_log = read_file(log_path)
    df_pretest = read_file(pretest_path)

    df_attempts = df_log[
        df_log["Event name"].str.contains(r"Quiz attempt (started|updated|submitted)",case=False, na=False)
    ]

    df_log_result = (df_attempts.groupby("User full name")
                     .agg({
                        "Time": "min",
                        "IP address": lambda x: list(x)
                    }).reset_index())

    df_log_result["Status"] = "Hadir"
    df_log_result["Catatan"] = df_log_result["IP address"].apply(catatan_ip_list)
    df_log_result["IP address"] = df_log_result["IP address"].apply(pilih_ip_tampil)

    df_pretest["User full name"] = (
        df_pretest["First name"].astype(str).str.strip() + " " +
        df_pretest["Last name"].astype(str).str.strip()
    )

    df_pretest["NPM"] = df_pretest["Email address"].str.split("@").str[0]
    df_pretest["Nilai"] = df_pretest["Grade/100.00"].astype(str).str.split(".").str[0]

    df_pretest_result = df_pretest[["NPM", "User full name", "Nilai"]].iloc[:-1]

    df_merge_result = pd.merge(
        df_log_result, 
        df_pretest_result,
        on="User full name", 
        how="right"
    )

    df_merge_result = df_merge_result[["Time", "IP address", "NPM", "User full name", "Nilai", "Status", "Catatan"]]

    df_merge_result = df_merge_result.sort_values(by="NPM", ascending=True)

    df_merge_result["Status"] = df_merge_result["Status"].fillna("Tidak Hadir")
    df_merge_result["Catatan"] = df_merge_result["Catatan"].fillna("-")
    df_merge_result["Time"] = df_merge_result["Time"].fillna("-")
    df_merge_result["IP address"] = df_merge_result["IP address"].fillna("-")
    df_merge_result["Nilai"] = df_merge_result["Nilai"].fillna("-")

    return df_merge_result
