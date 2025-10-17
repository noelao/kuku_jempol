@echo off
REM ======================================================
REM Git Automasi: Add, Commit, Push (Dinamis & Aman)
REM Gunakan: git-automate.bat "Pesan commit Anda di sini"
REM ======================================================

REM Pastikan Delayed Expansion diaktifkan untuk penanganan variabel yang aman
setlocal enabledelayedexpansion

REM --- 1. Ambil Argumen Pesan Commit ---
SET "COMMIT_MSG=%~1"

REM Cek apakah pesan commit diberikan
if "%COMMIT_MSG%"=="" (
    echo.
    echo [ERROR] Harap masukkan pesan commit sebagai argumen.
    echo Contoh: git-automate.bat "Perbaikan bug di header"
    goto :FAIL
)

echo.
echo ========================================
echo [INFO] Memulai Git Flow Otomatis
echo [COMMIT] Pesan: %COMMIT_MSG%
echo ========================================
echo.

REM --- 2. Git Add (Menambahkan semua file) ---
echo [STEP 1/3] ^(git add .^) Menambahkan semua perubahan...
git add .
if errorlevel 1 (
    echo [Gagal] Git add gagal. Periksa status repository.
    goto :FAIL
)
echo [SUCCESS] Git add selesai.
echo.

REM --- 3. Git Commit (Menggunakan pesan dari argumen) ---
echo [STEP 2/3] ^(git commit -m^) Melakukan commit...
git commit -m "%COMMIT_MSG%"
REM Cek errorlevel. Khusus untuk commit, jika tidak ada perubahan, 
REM perintah gagal (errorlevel 1), jadi kita tambahkan penanganan ini.
if errorlevel 1 (
    REM Cek apakah commit benar-benar gagal atau hanya karena "Nothing to commit"
    git status | findstr /i "nothing to commit" > nul
    if errorlevel 0 (
        echo [INFO] Tidak ada perubahan baru untuk di-commit. Melewati langkah ini.
    ) else (
        echo [Gagal] Git commit gagal. Ada konflik atau masalah lain.
        goto :FAIL
    )
) else (
    echo [SUCCESS] Git commit selesai.
)
echo.

REM --- 4. Git Push (Mendorong ke remote) ---
echo [STEP 3/3] ^(git push^) Mendorong perubahan ke remote repository...
git push
if errorlevel 1 (
    echo [Gagal] Git push gagal. Periksa koneksi atau jika Anda perlu 'git pull' terlebih dahulu.
    goto :FAIL
)
echo [SUCCESS] Git push selesai!
echo.

REM --- Akhir Berhasil ---
:SUCCESS
echo ========================================
echo [SELESAI] Operasi Git Selesai dengan Sukses. ✅
goto :END

REM --- Akhir Gagal ---
:FAIL
echo ========================================
echo [GAGAL] Operasi Git Terhenti karena Kesalahan. ❌
goto :END

REM --- Akhir Skrip ---
:END
pause
endlocal