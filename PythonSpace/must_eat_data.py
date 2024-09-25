"""
author : 민철
Description : 맛집리스트의 맛집 정보 조회, 추가, 수정, 삭제 (CRUD)
Date : 2024.09.25
Usage 조회: http://127.0.0.1:8000/must_eat/select?user_id=asd
Usage 추가: http://127.0.0.1:8000/must_eat/insert?user_id=asd&name=%EC%98%86%EC%A7%91&address=%EC%A7%84%EC%A7%9C%EC%98%86%EC%A7%91&longtitude=34.1234&latitude=134.12415&image=imagepath.jpg&review=%EC%A7%91%EB%B0%A5%EB%8A%90%EB%82%8C&rank=5
Usage 삭제: http://127.0.0.1:8000/must_eat/delete?seq=7
Usage 이미지 추가: http://127.0.0.1:8000/must_eat/upload
Usage 이미지 삭제: http://127.0.0.1:8000/must_eat/deleteFile/파일이름
Usage 이미지 받기: http://127.0.0.1:8000/must_eat/view/파일이름
"""

from fastapi import APIRouter, File, UploadFile
from fastapi.responses import FileResponse
import pymysql
import os
import shutil

router = APIRouter()

UPLOAD_FOLDER = 'MustEat'
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

def connect():
    conn = pymysql.connect(
        host='127.0.0.1',
        user='root',
        password='qwer1234',
        db='must_eat',
        charset='utf8'
    )
    return conn

# 유저가 가진 맛집 가져오기
@router.get("/select")
async def select(user_id: str=None):
    conn = connect()
    curs = conn.cursor()

    sql = "select * from list where user_id=%s"
    curs.execute(sql, user_id)
    rows = curs.fetchall()
    conn.close()
    print(rows)

    return {'results' : rows}

# 데이터 베이스에 데이터 추가 // 이미지 추가 : upload가 선행되어야함
@router.get("/insert")
async def insert(user_id: str=None, name: str=None, address: str=None, longtitude: str=None, latitude: str=None, image: str=None, review: str=None, rank: str=None):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = """
            INSERT INTO list
                (user_id, name, address, longtitude, latitude, image, review, rank_point) 
            VALUES 
                (%s, %s, %s, %s, %s, %s, %s, %s)
        """
        curs.execute(sql,(user_id, name, address, longtitude, latitude, image, review, rank))
        conn.commit()
        conn.close()
        return {'result' : 'OK'}
    except Exception as e:
        conn.close()
        print("Error:",e)
        return {'result' : 'Error'}
    
# 이미지 추가 (폴더 안에 이미지를 받아옴)
@router.post("/upload")
async def upload_file(file:UploadFile=File(...)):
    try:
        file_path = os.path.join(UPLOAD_FOLDER, file.filename)
        # write binary
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        return {'result' : 'OK'}
    except Exception as e:
        print("Error:",e)
        return({'result' : 'Error'})
    
# 이미지 삭제 (디렉토리 안의 이미지 삭제)
@router.delete("/deleteFile/{file_name}")
async def delete_file(file_name: str):
    try:
        file_path = os.path.join(UPLOAD_FOLDER, file_name)
        if os.path.exists(file_path):
            os.remove(file_path)
        return {'result' : 'OK'}
    except Exception as e:
        print("Error:", e)
        return {'result' : 'Error'}

# 이미지제외 업데이트시 실행
@router.get("/update")
async def update(seq: str=None, user_id: str=None, name: str=None, address: str=None, longtitude: str=None, latitude: str=None, review: str=None, rank: str=None):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = """
            UPDATE 
                list
            SET 
                user_id = %s,
                name = %s,
                address = %s,
                longtitude = %s,
                latitude= %s,
                review = %s,
                rank = %s
            WHERE
                seq = %s
        """
        curs.execute(sql,(user_id, name, address, longtitude, latitude, review, rank, seq))
        conn.commit()
        conn.close()
        return {'result' : 'OK'}
    except Exception as e:
        conn.close()
        print("Error:",e)
        return {'result' : 'Error'}

# 이미지 포함 업데이트
@router.get("/updateAll")
async def updateAll(seq: str=None, user_id: str=None, name: str=None, address: str=None, longtitude: str=None, latitude: str=None, image: str=None, review: str=None, rank: str=None):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = """
            UPDATE 
                list
            SET 
                user_id = %s,
                name = %s,
                address = %s,
                longtitude = %s,
                latitude= %s,
                image = %s,
                review = %s,
                rank = %s
            WHERE
                seq = %s
        """
        curs.execute(sql,(user_id, name, address, longtitude, latitude, image, review, rank, seq))
        conn.commit()
        conn.close()
        return {'result' : 'OK'}
    except Exception as e:
        conn.close()
        print("Error:",e)
        return {'result' : 'Error'}


# 이미지 전송
@router.get("/view/{file_name}")
async def get_file(file_name: str):
    file_path = os.path.join(UPLOAD_FOLDER, file_name)
    if os.path.exists(file_path):
        return FileResponse(path=file_path, filename=file_name)
    return {'results' : 'Error'}

# 데이터 베이스의 데이터 삭제
@router.get("/delete")
async def delete_sql(seq: str=None):
    conn = connect()
    curs = conn.cursor()
    print(seq)
    try:
        sql = "delete from list where seq=%s"
        curs.execute(sql,(seq))
        conn.commit()
        conn.close()
        return {'result' : 'OK'}
    except Exception as e:
        conn.close()
        print("Error:",e)
        return {'result' : 'Error'}