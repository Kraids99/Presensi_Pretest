from flask import Blueprint, render_template, request, send_file
import pandas as pd
from io import BytesIO
from .utils import read_file, catatan_ip_list, pilih_ip_tampil ,style_excel

urls = Blueprint('web', __name__)

@urls.route('/', methods=['GET'])
def index():
    return render_template('index.html')

@urls.route('/proses', methods=['POST'])
def proses():
    log_file = request.files['log']
    pretest_file = request.files['pretest']

    df_log = read_file(log_file)
    df_pretest = read_file(pretest_file)

    df_attempts = df_log[
        df_log["Event name"].str.contains("attempt started | attempt updated | attempt submitted", case=False, na=False)
    ]

    df_log_result = (df_attempts.groupby("User full name")
              .agg({
              "Time": "min",                 # ambil waktu paling awal
              "IP address": lambda x: list(x) # semua ip jadi list
          })
          .reset_index())
    
    df_log_result["Status"] = "Hadir"
    df_log_result["Catatan"] = df_log_result["IP address"].apply(catatan_ip_list)
    df_log_result["IP address"] = df_log_result["IP address"].apply(pilih_ip_tampil)

    df_pretest["User full name"] = (df_pretest["First name"].astype(str).str.strip() + " " +df_pretest["Last name"].astype(str).str.strip())
    df_pretest["NPM"] = df_pretest["Email address"].str.split("@").str[0]
    df_pretest["Nilai"] = df_pretest["Grade/100.00"].astype(str).str.split(".").str[0]

    df_pretest_result = df_pretest[["NPM", "User full name", "Nilai"]].iloc[:-1]

    df_merge_result = pd.merge(
        df_log_result, 
        df_pretest_result,
        on="User full name",
        how="right"
    )

    df_merge_result = df_merge_result[["Time", "IP address", "NPM", "User full name","Nilai", "Status", "Catatan"]].sort_values("NPM")

    df_merge_result = df_merge_result.sort_values(by="NPM", ascending=True)


    df_merge_result["Status"] = df_merge_result["Status"].fillna("Tidak Hadir")
    df_merge_result["Catatan"] = df_merge_result["Catatan"].fillna("-")
    df_merge_result["Time"] = df_merge_result["Time"].fillna("-")
    df_merge_result["IP address"] = df_merge_result["IP address"].fillna("-")
    df_merge_result["Nilai"] = df_merge_result["Nilai"].fillna("-")

    # styling & save to Excel
    output = style_excel(df_merge_result)

    return send_file(output,download_name="Hasil_Presensi.xlsx",as_attachment=True)
