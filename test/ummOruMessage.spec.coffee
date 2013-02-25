require './testing'

Encoder = require '..'

describe 'hl7encoder', ->

    e = null

    beforeEach ()->
          e = new Encoder
          e.NEW_LINE = '\n'

    describe 'generating an ORU HL7 message for UMM', ->
    
        it 'can create a simple message', ->

            encodedMessage = e.encode
                MSH:
                    _2:'CURASYSTEMS'
                    _3:'CURA_FO'
                    _5:'0001'
            
            encodedMessage.should.have.string 'MSH'
            encodedMessage.should.have.string 'MSH|'
            encodedMessage.should.have.string 'CURASYSTEMS'
            encodedMessage.should.have.string '0001'

        it 'can create a full ORC message as defined by UMM', ->

            encodedMessage = e.encode
                MSH:
                    _2:'CURASYSTEMS'
                    _3:'CURA_FO'
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
                    _18:['CURA_FOTO','001']
                    _19:'Wundbild'
                OBR:{}

            referenceMessage =  """
                MSH|^~\\&|CURASYSTEMS|CURA_FO||0001|||ORU||P|2.3
                PID||||30006108
                ORC|DT||4711||CM|||||560200|214714|||||100022554711||CURA_FOTO^001|Wundbild
                OBR
                """

            encodedMessage.should.equal referenceMessage

    describe 'encode a Segment', ->

        it 'can encode a MSH segment', ->
            segment = e.encodeSegment 'MSH',
                    _1: e.DEFAULT_SEPARATORS
                    _2:'CURASYSTEMS'
                    _3:'CURA_FO'
                    _5:'0001'
                    _8:'ORU'
                    _10:'P'
                    _11:'2.3'

            segment.should.equal 'MSH|^~\\&|CURASYSTEMS|CURA_FO||0001|||ORU||P|2.3'



        it 'can encode an ORC segment', ->

            segment = e.encodeSegment 'ORC',
                    _1: 'DT'
                    _3:'4711'
                    _5:'CM'
                    _10:560200
                    _11:214714
                    _16:100022554711
                    _18:['CURA_FOTO','001']
                    _19:'Wundbild'


            segment.should.equal 'ORC|DT||4711||CM|||||560200|214714|||||100022554711||CURA_FOTO^001|Wundbild'
