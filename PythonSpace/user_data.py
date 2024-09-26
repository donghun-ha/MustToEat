from fastapi import File, UploadFile, APIRouter
from fastapi.responses import FileResponse
import pymysql
import os
import shutil
'http://127.0.0.1:8000/user/insert?id=123&password=11&name=44&phone=4555&address=qqqq&email=rrrr'
router = APIRouter()

@router.get("/")
async def read_items():
    return {'message':'Read all items'}

UPLOAD_FOLDER = 'uploads'
if not os.path.exists(UPLOAD_FOLDER) :
    os.makedirs(UPLOAD_FOLDER)

def connect() :
    conn = pymysql.connect(
        host='127.0.0.1',
        user='root',
        password='qwer1234',
        db='must_eat',
        charset='utf8'
    )
    return conn

@router.get("/insert")
async def insert(id: str=None, password: str=None, name: str=None, phone: str=None, address: str=None, email: str=None) :
    conn = connect()
    curs = conn.cursor()
    print(phone)
    try :
        sql = "insert into user(id, password, name, phone, address, email) values (%s,%s,%s,%s,%s,%s)"
        curs.execute(sql, (id, password, name, phone, address, email))
        conn.commit()
        conn.close()
        return {'result' : 'Cool'}
    except Exception as e :
        conn.close()
        print("Error :", e)
        return {'result' : 'Noo'}
    
@router.get("/login")
async def login(id: str=None, password: str=None) :
    conn = connect()
    curs = conn.cursor()

    try :
        sql = "select Count(*) from user where id=%s and password=%s"
        curs.execute(sql, (id, password))
        user = curs.fetchone()
        print(user)
        conn.close()
        print(user[0])

        if user[0] == 1 :
            return {"available" : True, "message" : "로그인 되었습니다."}
        else :
            return {"available" : False, "message" : "비밀번호가 일치하지 않습니다."}

        
    except Exception as e :
        conn.close()
        print("Error :", e)
        return {'result' : 2, "message" : '로그인 처리 중 오류가 발생했습니다.'}
        
    

@router.get("/check_id")
async def check_id(id: str=None) :
    conn = connect()
    curs = conn.cursor()

    try :
        sql = "select Count(*) from user where id = %s"
        curs.execute(sql, (id))
        result = curs.fetchone()
        conn.close()
        
        if result[0] > 0 :
            return {"available" : False, "message" : "이미 등록된 ID입니다."}
        else :
            return {"available" : True, "message" : "사용가능한 ID입니다."}
    except Exception as e :
        conn.close()
        print("Error:", e)
        return {"error" : "An error occurred while checking the ID."}

    
@router.get("/update")
async def update(id: str=None, name: str=None, phone: str=None, address: str=None, email: str=None) :
    conn = connect()
    curs = conn.cursor()

    try :
        sql = "update user set name=%s, phone=%s, address=%s, email=%s where id=%s"
        curs.execute(sql, (name, phone, address, email, id))
        conn.commit()
        conn.close()
        return {'result' : 'Cool'}
    except Exception as e :
        conn.close()
        print("Error :", e)
        return {'result' : 'Noo'}
    
@router.get("/updatePW")
async def updatePW(id: str=None, password: str=None):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = "update user set password=%s where id=%s"
        curs.execute(sql,(password,id))
        conn.commit()
        conn.close()
        return {'result' : 'Cool'}
    except Exception as e : 
        conn.close()
        print("Error :", e)
        return {'result' : 'Noo'}

@router.get("/updateAll")
async def updateAll(id: str=None, password: str=None, name: str=None, phone: str=None, address: str=None, email: str=None, image: str=None) :
    conn = connect()
    curs = conn.cursor()

    try :
        sql = "update user set password=%s, name=%s, phone=%s, address=%s, email=%s, image=%s where id=%s"
        curs.execute(sql, (password, name, phone, address, email, image, id))
        conn.commit()
        conn.close()
        return {'result' : 'Cool'}
    except Exception as e :
        conn.close()
        print("Error :", e)
        return {'result' : 'Error'}
    
@router.post("/upload")
async def upload_file(file:UploadFile=File(...)) :
    try :
        file_path = os.path.join(UPLOAD_FOLDER, file.filename)
        with open(file_path, "wb") as better :
            shutil.copyfileobj(file.filename, better)
        return {'result' : 'Cool'}
    except Exception as e :
        print("Error :", e)
        return ({'result' : 'Error'})
    
@router.get("/select")
async def select(id: str=None) :
    conn = connect()
    curs = conn.cursor()

    sql = 'select id, password, name, phone, address, email, image from user where id=%s'
    curs.execute(sql, (id))
    rows = curs.fetchone()
    conn.close()
    print(rows)

    return {'result' : rows}

@router.get("/view/{file_name}")
async def get_file(file_name: str) :
    file_path = os.path.join(UPLOAD_FOLDER, file_name)
    if os.path.exists(file_path) :
        return FileResponse(path = file_path, filename=file_name)
    return {"result" : 'Noo'}

@router.delete("deleteFile/{file_name}")
async def delete_file(file_name: str) :
    try :
        file_path = os.path.join(UPLOAD_FOLDER, file_name)
        if os.path.exists(file_path) :
            os.remove(file_path) 
        return {'result' : 'OK'}
    except Exception as e :
        print("Error", e)
        return {'result' : 'Noo'}
    
@router.get("/delete")
async def delete(id: str=None) :
    conn = connect()
    curs = conn.cursor()

    try :
        sql = "delete from user where id = %s"
        curs.execute(sql, (id))
        conn.commit()
        conn.close()
        return {'results' : 'Cool'}
    except Exception as e :
        conn.close()
        print('Error :', e)
        return {'results' : 'Error'}

