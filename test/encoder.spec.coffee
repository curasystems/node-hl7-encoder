require './testing'

Encoder = require '../lib/encoder'

describe 'HL7 Encoder', ->

    e = null

    beforeEach ()->
          e = new Encoder NEW_LINE:'\n'

    describe 'generating an ORU HL7 message for UMM', ->
    
        it 'can create a simple message', ->

            encodedMessage = e.encode
                MSH:
                    _2:'COMPANY'
                    _3:'APP'
                    _5:'0001'
            
            encodedMessage.should.have.string 'MSH'
            encodedMessage.should.have.string 'MSH|'
            encodedMessage.should.have.string 'COMPANY'
            encodedMessage.should.have.string '0001'

        it 'can encode an ORC message with an empty segment', ->

            encodedMessage = e.encode
                MSH:
                    _2:'COMPANY'
                    _3:'APP'
                    _5:'0001'
                    _8:'ORU'
                    _10:'P'
                    _11:'2.3'
                PID:
                    _4:30006108
                ORC:
                    _1:'DT'
                    _3:4711
                    _5:'CM'
                    _10:560200
                    _11:214714
                    _16:100022554711
                    _18:['APP_IMAGE','001']
                    _19:'Test Image'
                OBR:{}

            referenceMessage =  """
                MSH|^~\\&|COMPANY|APP||0001|||ORU||P|2.3
                PID||||30006108
                ORC|DT||4711||CM|||||560200|214714|||||100022554711||APP_IMAGE^001|Test Image
                OBR
                """

            encodedMessage.should.equal referenceMessage

    describe 'encode a Segment', ->

        it 'can encode a MSH segment', ->
            segment = e.encodeSegment 'MSH',
                    _1: e.DEFAULT_SEPARATORS
                    _2:'COMPANY'
                    _3:'APP'
                    _5:'0001'
                    _8:'ORU'
                    _10:'P'
                    _11:'2.3'

            segment.should.equal 'MSH|^~\\&|COMPANY|APP||0001|||ORU||P|2.3'



        it 'can encode an ORC segment', ->

            segment = e.encodeSegment 'ORC',
                    _1: 'DT'
                    _3:'4711'
                    _5:'CM'
                    _10:560200
                    _11:214714
                    _16:100022554711
                    _18:['APP_IMAGE','001']
                    _19:'Test Image'


            segment.should.equal 'ORC|DT||4711||CM|||||560200|214714|||||100022554711||APP_IMAGE^001|Test Image'
