import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

import time
import board
import adafruit_dht

from gpiozero import LED

# GPIO 핀 번호 설정
fan_pin = 4

# Fan 객체 생성
fan = LED(fan_pin)

#상품 정보
productName = 'closs'
productSerial = 'closs1'

def Write():
    # Write 함수 내용은 주석 처리된 상태로 남겨둠
    time.sleep(0.0)

def Read():
    global fan
    db = firestore.client()
    doc_ref = db.collection(productName).document(productSerial)
    
    print("함수 Read가 실행되었습니다.")
    try:
        doc = doc_ref.get()
        print(u'Document data: {}'.format(doc.to_dict()))
        data = doc.to_dict().get('data')
        print(data)
        if data == 'on':
            print('on')
            
            #fan.on()
        else:
            print('off')
            #fan.off()
            
    #except google.cloud.exceptions.NotFound:
        #print(u'No such document!')
    except Exception as e:  # 기타 예외 처리
        print("에러 발생:", e)

def main():
    try: 
        cred = credentials.Certificate("/home/jbs1/Closs/mossis-family-firebase-adminsdk-bgai4-9ac292b452.json")
        firebase_admin.initialize_app(cred)
        
        flag = True  # 처음에 Write 함수를 실행하기 위한 플래그
        
        while True:
            try:
                if flag:
                    #Write()  # flag가 True일 때 Write 함수 실행
                    time.sleep(0.0)
                else:
                    Read()  # flag가 False일 때 Read 함수 실행
                    #time.sleep(0.5)
                    
                flag = not flag  # flag를 토글하여 다음에 실행할 함수를 결정
            except Exception as e:  # 기타 예외 처리
                print("에러 발생:", e)
    except Exception as e:  # 기타 예외 처리
        print("에러 발생:", e)

if __name__ == "__main__":
    main()
