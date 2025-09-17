# main.py  (Python backend untuk Flutter)
from flask import Flask, request, send_file
from io import BytesIO
from presensi import proses_presensi
from excel_format import format_excel   # jika mau styling

app = Flask(__name__)

@app.route("/proses", methods=["POST"])
def proses():
    # Ambil 2 file dari Flutter
    log_file = request.files["log"]
    pretest_file = request.files["pretest"]

    # Proses data
    df = proses_presensi(log_file, pretest_file)

    # Simpan hasil ke memory
    output = BytesIO()
    df.to_excel(output, index=False)
    output.seek(0)

    # Tambahkan styling (opsional)
    output = format_excel(output)

    # Kirim kembali ke Flutter sebagai file Excel
    return send_file(output,
                     download_name="Hasil_Presensi.xlsx",
                     as_attachment=True)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)   # jalankan server
