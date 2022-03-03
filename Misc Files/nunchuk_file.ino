# include "Nunchuk.h"

bool sent_0;
void setup() {
  Serial.begin(19200);
  Wire.begin();

  Wire.setClock(400000);
  sent_0 = false;
  nunchuk_init();

}

void loop() {
  // put your main code here, to run repeatedly:

  delayMicroseconds(2);

  if (nunchuk_read()) {
    int8_t x = nunchuk_joystickX();
    int8_t y = nunchuk_joystickY();
    int8_t z = nunchuk_buttonZ();
    int8_t c = nunchuk_buttonC();
     if(x == -1) x = 0;
    if (x == 0 && y== 0 && z == 0 && !sent_0) {
      Serial.write(x);
      Serial.write(y);
      Serial.write(z);
      //Serial.write(c);
      sent_0 = true;
    }
    else if (x == 0 && y == 0  && z == 0 && sent_0) {
      // do nothing
    }
    else {
      Serial.write(x);
      Serial.write(y);
      Serial.write(z);
      //Serial.write(c);
      sent_0 = false;
    }
  }

  

  

}
