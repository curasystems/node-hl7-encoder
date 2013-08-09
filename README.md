node-hl7-encoder
================

A very simple JSON to hl7 2.x encoder

## Install

    npm i hl7-encoder

## Example

    var encoder = require('hl7-encoder');

    var message = {
      MSH:{
        _2:'COMPANY',
        _3:'APP',
        _5:'0001',
        _8:'ORU',
        _10:'P',
        _11:'2.3'
        },
      PID:{
        _4: 30006108
        },
      ORC: {
        _1:'DT',
        _3:4712,
        _5:'CM',
        _10:560200,
        _11:214716,
        _16:600022554711,
        _18:['APP_IMAGE','001'],
        _19:'Test Image'
        },
      OBR:{}
    };

    var encodedMessage = encoder.encode(message);
    console.log(encodedMessage);

  Encoded message will then be:

    MSH|^~\\&|COMPANY|APP||0001|||ORU||P|2.3
    PID||||30006108
    ORC|DT||4712||CM|||||560200|214716|||||600022554711||APP_IMAGE^001|Test Image
    OBR



