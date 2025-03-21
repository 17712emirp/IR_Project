# 🕸️Web Crawler

### ⚙️ วิธีใช้งาน

1. ติดตั้งไลบรารีที่จำเป็น
``` bash
pip install -r requirements.txt
```

2. เริ่มต้นรัน Crawler
``` bash
python crawler.py
```


### 📁 โครงสร้างโฟลเดอร์

```bash
.
├── crawler.py              # โค้ดหลักของโปรเจกต์
├── html/                   # โฟลเดอร์เก็บไฟล์ HTML
├── logs/                   # เก็บ log ต่าง ๆ
│   ├── dns_log.txt
│   ├── robots_log.txt
│   ├── fetch_log.txt
│   ├── save_log.txt
│   └── process_log.txt
├── list_robots.txt         # รายชื่อเว็บที่มี robots.txt
└── README.md               # ไฟล์ README นี้
