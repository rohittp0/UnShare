# 📂 UnShare

**UnShare** is a simple cross-platform Flutter app that lets you **receive any file shared from
another app and automatically saves it to your Downloads folder**.

---

## 🛠 Features

* Receive files from any app that supports the system "Share" menu
* Save shared files directly to the **Downloads** folder
* Opens the Downloads folder in the system file manager
* Works on both **Android and iOS**

---

## 🚀 How to Use

1. In any app (e.g. WhatsApp, Files, Gmail), tap the **Share** button
2. Choose **UnShare** from the list
3. The file is saved to your **Downloads** folder

---

## 🚫 Why This Exists

The idea for **UnShare** came from frustration with trying to save a file from WhatsApp to local
storage. Apps often hide or limit where files are saved. **UnShare** fixes that with one tap.

---

## 📂 Installation

```bash
git clone https://github.com/your-username/unshare.git
cd unshare
flutter pub get
flutter run
```

---

## 📲 Platform Support

* ✅ **Android** (API 21+)
* ✅ **iOS** (13+)

> On iOS, files are saved to the app's sandboxed documents directory, accessible via the Files app
> under "On My iPhone" > "UnShare"

---

## 📁 Downloads Folder Path

| Platform | Path                           |
|----------|--------------------------------|
| Android  | `/storage/emulated/0/Download` |
| iOS      | `<app sandbox>/Documents/`     |

---

## 🤔 FAQ

**Q: Can I customize the save folder?**

A: Not in this version. Files go directly to Downloads (or Documents on iOS).

**Q: Does it support videos, PDFs, images?**

A: Yes. Any file shared through the OS-level share intent.

**Q: Will it overwrite files with the same name?**

A: Yes, it will overwrite files with the same name in the Downloads folder.

