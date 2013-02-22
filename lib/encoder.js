var Hl7Encoder, _, _s,
  __hasProp = {}.hasOwnProperty;

_ = require('underscore');

_s = require('underscore.string');

module.exports = Hl7Encoder = (function() {
  var COMPONENT_SEPARATOR, DEFAULT_SEPARATORS, FIELD_SEPARATOR, NEW_LINE;

  function Hl7Encoder() {}

  FIELD_SEPARATOR = '|';

  COMPONENT_SEPARATOR = '^';

  NEW_LINE = '\n';

  DEFAULT_SEPARATORS = "" + COMPONENT_SEPARATOR + "~\\&";

  Hl7Encoder.prototype.encode = function(message) {
    var encodedMessage, segments;
    segments = this._encodeAllObjectPropertiesAsSegments(message);
    encodedMessage = segments.join(NEW_LINE);
    return encodedMessage;
  };

  Hl7Encoder.prototype._encodeAllObjectPropertiesAsSegments = function(object) {
    var segmentName, value, _results;
    _results = [];
    for (segmentName in object) {
      if (!__hasProp.call(object, segmentName)) continue;
      value = object[segmentName];
      _results.push(this.encodeSegment(segmentName, value));
    }
    return _results;
  };

  Hl7Encoder.prototype.encodeSegment = function(name, segment) {
    var fields;
    if (name === 'MSH') {
      if (!segment._1) {
        segment._1 = DEFAULT_SEPARATORS;
      }
    }
    fields = this._extractAllNumberedPropertiesIntoSparseArray(segment);
    segment = name + this._joinAllFieldsInSparseArrayIntoASingleLine(fields);
    return segment;
  };

  Hl7Encoder.prototype._extractAllNumberedPropertiesIntoSparseArray = function(object) {
    var PROPERTY_PREFIX, field, fieldNo, fields, value;
    PROPERTY_PREFIX = '_';
    fields = [];
    for (field in object) {
      if (!__hasProp.call(object, field)) continue;
      value = object[field];
      if (!_s.startsWith(field, PROPERTY_PREFIX)) {
        continue;
      }
      fieldNo = field.slice(1);
      fields[fieldNo] = value;
    }
    return fields;
  };

  Hl7Encoder.prototype._joinAllFieldsInSparseArrayIntoASingleLine = function(fields) {
    var fieldIndex, fieldValue, result, _i, _ref;
    result = '';
    if (fields.length < 2) {
      return result;
    }
    for (fieldIndex = _i = 1, _ref = fields.length - 1; 1 <= _ref ? _i <= _ref : _i >= _ref; fieldIndex = 1 <= _ref ? ++_i : --_i) {
      fieldValue = fields[fieldIndex];
      result += FIELD_SEPARATOR;
      result += this.encodeField(fieldValue);
    }
    return result;
  };

  Hl7Encoder.prototype.encodeField = function(value) {
    if (!value) {
      return '';
    }
    if (_.isArray(value)) {
      return value.join(COMPONENT_SEPARATOR);
    } else {
      return value;
    }
  };

  return Hl7Encoder;

})();
