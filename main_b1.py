import keyboard
try: 
    import subprocess
    import os

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

    dhtDevice = adafruit_dht.DHT22(board.D27)

    beforeTemp = ''
    beforeHum = ''

    def execute_command(command):
        try:
            result = subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            output = result.stdout.decode('utf-8')
            error = result.stderr.decode('utf-8')
            if output:
                print("명령 실행 결과:", output)
            if error:
                print("에러 발생:", error)
        except subprocess.CalledProcessError as e:
            print("에러 발생:", errror)
            
    def execute_fan(fan):
        if(fan=="on"):
            globals()['fan'].on()
            print("fan: on")
        if(fan=="off"):
            globals()['fan'].off()
            print("fan: off")

    def Write():
        try:
            print("function Write >")
            db = firestore.client()
            batch = db.batch()
            doc_ref = db.collection(productName).document(productSerial)
            doc = doc_ref.get()
            temp = dhtDevice.temperature
            hum = dhtDevice.humidity
            global beforeTemp
            global beforeHum
            if(beforeTemp != temp):
                beforeTemp = temp
                batch.update(doc_ref, {'temp': temp})
                #doc_ref.update({'temp': temp})
                print("temp is batched by ", temp)
            else:
                print("temp is same with beforeTemp")
                
            if(beforeHum != hum):
                beforeHum = hum
                #doc_ref.update({'hum': hum})
                batch.update(doc_ref, {'hum': hum})
                print("hum is batched by ", hum)
            else:
                print("hum is same with beforeHum")
                
            batch.commit()
                
        except Exception as e:
            print("에러 발생:", e)

    def Read():
        print("function Read >")
        try:
            db = firestore.client()
            doc_ref = db.collection(productName).document(productSerial)
            doc = doc_ref.get()
            command = doc.to_dict().get('command')
            fan = doc.to_dict().get('fan')
            doc_ref.update({'command': ''})
            
            if command:
                print('command: ', command)
                execute_command(command)
            if fan:
                print('fan: ', fan)
                execute_fan(fan)
                
                
        except Exception as e:  # 기타 예외 처리
            print("에러 발생:", e)

    def main():
        try: 
            firebase_cred_filename = "fireKey.json"
            current_dir = os.path.dirname(os.path.abspath(__file__))
            firebase_cred_path = os.path.join(current_dir, firebase_cred_filename)
            cred = credentials.Certificate(firebase_cred_path)
            firebase_admin.initialize_app(cred)
            global fan
            
            flag = True  # 처음에 Write 함수를 실행하기 위한 플래그
            countNum = 0
            
            while True:
                time.sleep(2)
                if flag:
                    countNum = countNum+1
                    if countNum==3:
                        Write()  # flag가 True일 때 Write 함수 실행
                        countNum = 0
                else:
                    Read()  # flag가 False일 때 Read 함수 실행
                    
                flag = not flag  # flag를 토글하여 다음에 실행할 함수를 결정
        except Exception as e:  # 기타 예외 처리
            print("에러 발생:", e)

    if __name__ == "__main__":
        main()
except Exception as e:
    print("에러 발생:", e)
    # 재부팅
    print("Rebooting... in 5 seconds, if you wanna stop you can press ctrl+c")
    time.sleep(5)  # 5초 대기
    subprocess.run(["sudo", "reboot"])
