const fs = require('fs').promises;
const path = require('path');

// ==========================================================
// 1. FUNGSI TELUSURI FOLDER (SAMA SEPERTI SEBELUMNYA)
// ==========================================================
async function telusuriFolderDanKelompokkan(rootPath, currentPath, groups = {}) {
    try {
        const dirents = await fs.readdir(currentPath, { withFileTypes: true });
        const relativeFolderPath = path.relative(rootPath, currentPath) || 'root';

        if (!groups[relativeFolderPath]) {
            groups[relativeFolderPath] = [];
        }

        for (const dirent of dirents) {
            const fullPath = path.join(currentPath, dirent.name);

            if (dirent.isDirectory()) {
                await telusuriFolderDanKelompokkan(rootPath, fullPath, groups);
            } else if (dirent.isFile()) {
                groups[relativeFolderPath].push(dirent.name);
            }
        }
        return groups;
    } catch (err) {
        console.error(`Gagal menelusuri path ${currentPath}:`, err.message);
        return groups;
    }
}

// ==========================================================
// 2. LOGIKA UTAMA: MEMBUAT DAN MENULIS FILE JSON
// ==========================================================

async function buatFileJsonDaftarFile(folderRoot, namaFileOutput) {
    try {
        // Pindai folder
        const resultsObject = await telusuriFolderDanKelompokkan(folderRoot, folderRoot);

        // Bersihkan kunci 'root' jika kosong
        if (resultsObject['root'] && resultsObject['root'].length === 0) {
            delete resultsObject['root'];
        }

        // Konversi objek JavaScript ke string JSON yang rapi (indentasi 2 spasi)
        const jsonString = JSON.stringify(resultsObject, null, 2);

        // Tulis string JSON ke file
        await fs.writeFile(namaFileOutput, jsonString, 'utf8');

        console.log(`\n✅ Berhasil! Daftar file telah disimpan ke ${namaFileOutput}`);
        console.log(`   (Dicatat pada ${new Date().toLocaleTimeString()})`);

    } catch (error) {
        console.error('\n❌ GAGAL MENULIS FILE JSON:', error.message);
    }
}

// --- Panggil Fungsi ---
const rootDirectory = path.resolve(__dirname, 'asset/image/gear_hero'); // Ganti dengan folder Anda
const outputFilename = 'api_asset_gearHero.json';

// Panggil fungsi utama
buatFileJsonDaftarFile(rootDirectory, outputFilename);