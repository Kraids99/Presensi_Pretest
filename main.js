let logFileUploaded = false;
let pretestFileUploaded = false;

// mengubah ukuran dalam byte
function formatFileSize(bytes) {
  if (bytes === 0) return "0 Bytes";
  // basis konversi (1 KB = 1024 Bytes).
  const k = 1024;
  const sizes = ["Bytes", "KB", "MB", "GB"];
  // menentukan index unit yang tepat berdasarkan besar bytes ("Bytes", "KB", "MB", "GB").
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + " " + sizes[i];
}

function updateStatus() {
  const statusIndicator = document.getElementById("statusIndicator");
  const downloadBtn = document.getElementById("downloadBtn");

  if (logFileUploaded && pretestFileUploaded) {
    statusIndicator.className = "status-indicator status-ready";
    statusIndicator.innerHTML = "✅ Siap untuk diproses";
    downloadBtn.disabled = false;
  } else if (logFileUploaded || pretestFileUploaded) {
    statusIndicator.className = "status-indicator status-waiting";
    statusIndicator.innerHTML = "📤 Menunggu satu file lagi";
  } else {
    statusIndicator.className = "status-indicator status-waiting";
    statusIndicator.innerHTML = "⏳ Menunggu file log dan pretest";
  }
}

function handleFileUpload(inputId, fileType) {
  const input = document.getElementById(inputId);
  const uploadArea = document.getElementById(
    inputId.replace("File", "UploadArea")
  );
  const fileInfo = document.getElementById(inputId + "Info");
  const fileName = document.getElementById(inputId + "Name");
  const fileSize = document.getElementById(inputId + "Size");

  // Drag and drop functionality
  uploadArea.addEventListener("dragover", (e) => {
    e.preventDefault();
    uploadArea.classList.add("dragover");
  });

  uploadArea.addEventListener("dragleave", () => {
    uploadArea.classList.remove("dragover");
  });

  uploadArea.addEventListener("drop", (e) => {
    e.preventDefault();
    uploadArea.classList.remove("dragover");
    const files = e.dataTransfer.files;
    if (files.length > 0) {
      input.files = files;
      input.dispatchEvent(new Event("change"));
    }
  });

  input.addEventListener("change", function () {
    if (input.files.length > 0) {
      const file = input.files[0];

      // Update file info
      fileName.textContent = file.name;
      fileSize.textContent = formatFileSize(file.size);
      fileInfo.classList.add("show");
      uploadArea.classList.add("file-selected");

      // Update status
      if (fileType === "log") {
        logFileUploaded = true;
      } else {
        pretestFileUploaded = true;
      }

      updateStatus();

      // Show success animation
      uploadArea.style.transform = "scale(1.02)";
      setTimeout(() => {
        uploadArea.style.transform = "scale(1)";
      }, 200);
    }
  });
}

function downloadHasil() {
  if (!logFileUploaded || !pretestFileUploaded) {
    alert("Mohon unggah kedua file terlebih dahulu!");
    return;
  }

  // Show progress bar
  const progressBar = document.getElementById("progressBar");
  const progressFill = document.getElementById("progressFill");
  const downloadBtn = document.getElementById("downloadBtn");

  progressBar.style.display = "block";
  downloadBtn.disabled = true;
  downloadBtn.textContent = "⏳ Memproses...";

  // Simulate processing
  let progress = 0;
  const interval = setInterval(() => {
    progress += Math.random() * 20;
    if (progress > 100) progress = 100;

    progressFill.style.width = progress + "%";

    if (progress === 100) {
      clearInterval(interval);

      setTimeout(() => {
        // Create dummy download
        const link = document.createElement("a");
        link.href =
          "data:text/csv;charset=utf-8," +
          encodeURIComponent("Nama,NIM,Hadir\nContoh Student,123456,Ya");
        link.download =
          "presensi_mahasiswa_" +
          new Date().toISOString().split("T")[0] +
          ".csv";
        link.click();

        // Reset UI
        progressBar.style.display = "none";
        progressFill.style.width = "0%";
        downloadBtn.disabled = false;
        downloadBtn.textContent = "💾 Download File Presensi";

        alert("File presensi berhasil didownload!");
      }, 500);
    }
  }, 100);
}

// Initialize file handlers
document.addEventListener("DOMContentLoaded", function () {
  handleFileUpload("logFile", "log");
  handleFileUpload("pretestFile", "pretest");
});
