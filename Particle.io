#include <InternetButton.h>
InternetButton b = InternetButton();

int sensorPin = A0; // This is where your sensor is plugged in.
int analogvalue; // Here we are declaring the integer variable analogvalue, which we will use later to store the value of the reader.
int vWet = 1700;
int vDry = 3503;
double pWet;
int numLeds;
void setup() {
    pinMode(sensorPin,INPUT);  // Our sensor pin is input (reading)
    // We are going to declare a Particle.variable() here so that we can access the value from the cloud.
    Particle.variable("analogvalue", &analogvalue, INT);
    Particle.variable("pWet", &pWet, DOUBLE);
    Particle.variable("numLeds", &numLeds, INT);
    b.begin();
}

void loop() {
    analogvalue = analogRead(sensorPin);
    pWet = numLightsWet(analogvalue, vWet, vDry);
    numLeds = (int)(pWet/8);
    b.allLedsOff();
    delay(300);
    for(int i=1; i<13; i++){
        if(i<numLeds){
            b.ledOn(i, 0, 255, 0);
        }
    }
    delay(1000);
}

int numLightsWet(int v, int vWet, int vDry){
    double p = (1- (double)(v-vWet)/(vDry-vWet)) * 100;
    return p;
}
