# วิธีการติดตั้งและการแแสดงผลให้พร้อมใช้งาน
### 1.ติดตั้ง IDE และดาวน์โหลดไฟล์ทั้งหมด
1.1 ติดตั้ง [IDE Eclipse Java EE](https://www.eclipse.org/downloads/packages/release/2024-12/r/eclipse-ide-enterprise-java-and-web-developers)

1.2 ดาวน์โหลด [Lucene เวอร์ชัน 10.1.0 (ทั้ง source และ binary)](https://lucene.apache.org)

1.3 ดาวน์โหลด [Apache Tomcat เวอร์ชัน 9](http://tomcat.apache.org/)

1.3 ดาวน์โหลดโฟลเดอร์ ``extent_used_library`` และ ``src_main_webapp`` ลงเครื่อง

1.4 ดาวน์โหลดไฟล์ ``IndexWithMoreInfo`` กับ ``html_all_web.zip`` (แตกไฟล์ให้พร้อมใช้งาน)

### 2.สร้างโปรเจกต์สำหรับสร้างไฟล์ดัชนี
2.1 สร้างโปรเจกต์ใหม่ชนิด Java Project ตั้งชื่อโปรเจกต์ตามที่ต้องการ **(ในที่นี้จะสมมุติชื่อเป็น <ins>KU-search</ins>)**  
และเลือกใช้ JRE environment เป็น JavaSE-21 จากนั้นกด Finish

2.2 คลิกขวาที่โฟลเดอร์ **KU-search** ที่แท็บไดเร็กเตอร๊่ด้านซ้ายและเลือก BuildPath -> Add external archieves จากนั้นให้เพิ่ม library ทั้งหมดในโฟลเดอร์ extent_used_library

2.3 ลากไฟล์ ``IndexWithMoreInfo`` ที่ดาวน์โหลดเรียบร้อยเข้าไปที่โฟลเดอร์ที่ชื่อ src (เลือกแบบ Copy File)

2.4 แก้ Error ที่เกิดขึ้นในไฟล์ ``IndexWithMoreInfo`` ทั้งหมดเช่น การย้าย Package หรือการ Import Library อื่นๆที่จำเป็น
> [!TIP]
> เราสามารถแก้ Error ได้ง่ายๆโดยการวางเคอเซอร์บนจุดที่ Error และเลือกวิธีที่เราต้องการ.

2.5 เมื่อแก้ Error ครบแล้ว  
ให้เราคลิกขวาที่ไฟล์ ``IndexWithMoreInfo`` ที่แท็บไดเร็กเตอร๊่ด้านซ้าย เลือก Run As -> Run Configurations จากนั้นจะมีหน้าต่าง Run Configurations แสดงออกมาให้คลิกไฟล์ IndexWithMoreInfo ที่อยู่ในแท็บด้านซ้าย(กรณีที่ไม่เจอให้คลิกที่ Java Application เพื่อแสดงไฟล์ทั้งหมด) แล้วเลือกหัวข้อ Argument แล้วใส่ ``-index (Path ของโฟลเดอร์ที่เก็บอินเด็กซ์) -docs (Path ของโฟลเดอร์ html_all_web)`` ในช่อง Program Argument จากนั้นกด Run

2.6 รอโปรแกรมสร้างไฟล์ดัชนีจนกว่าจะเสร็จ
### 3.เตรียมโปรเจกต์สำหรับทำ Web app และ Tomcat Server
3.1 สร้าง Server ขึ้นมาใหม่โดยกดที่หัวข้อ Server ที่แท็บด้านล่าง(กรณีที่ไม่มีให้เลือก window -> show view -> other -> Server) เลือก Tomcat v.9.0 server กด next -> Browse Tomcat folder path กด Finish 
จากนั้น Configure Server Tomcat ให้ Server Location = use tomcat installation, ให้ port = 8080

3.2 สร้าง new project -> Web -> Dynamic Web project ตั้งชื่อโปรเจกต์ **(สมมุติชื่อ <ins>MyWebSearch</ins>)** ใช้ apache Tomcat แล้วกด Finish

3.3 คลิก src -> main -> webapp แล้วลากไฟล์ทั้งหมดในโฟล์เดอร์ src_main_webapp ใส่เข้าไป(เลือกแบบ Copy File) 

3.4 คลิกขวาที่ MyWebPage เลือก BuildPath -> Configure Build Path... -> เลือกหัวข้อ Library -> module path -> add library -> web app library -> Apply and Close 

3.5 ลากไลบรารีใน ``Extent_used_library`` ลงใน ``src/main/webapp/WEB-INF/lib`` เพียงเท่านี้เราได้เพิ่มไลบรารีที่เราต้องใช้ครบแล้ว

3.6 ในไฟล์ configuration.jsp แก้ไขตรง indexLocation เป็น IndexPath ของเราโดยต้องเปลี่ยน ``'\' -> '\\'`` ด้วย

### 4.เปิดใช้งาน Web Application Search Engine
4.1 กดที่หัวข้อ Server ที่แท็บด้านล่าง คลิกขวาที่ Tomcat -> start ตอนนี้ Tomcat Server พร้อมใช้งานแล้ว

4.2 คลิกขวาที่ MyWebSearch -> Rus As -> Rus on server -> เลือก Tomcat -> Finish

4.3 Coffee Cup Manga Online Search Engine พร้อมใช้งานแล้ว :+1:
