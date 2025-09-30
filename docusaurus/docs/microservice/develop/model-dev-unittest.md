---
id: model-dev-unittest
title: Model Dev & Unit Test
---

## Instruction
Write the program for the Model and its Unit Test.

## Overview
Focus on creating models that represent the system's data and business logic accurately, as well as developing reliable unit tests.

## Goals
- Develop models that align with API Design and Swagger specifications.
- Ensure models reflect the physical data model, including database schema.
- Create corresponding unit tests to validate model functionality and integrity.

## Sample
**Note: Utilize the example code below as a template, adjusting the details to fit your model design and testing needs.**


### Schema Sample Code
```javascript
// ExampleSchema.js
const mongoose = require('mongoose');

const exampleSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    trim: true
  },
  status: {
    type: String,
    required: true,
    enum: ['active', 'completed', 'archived']
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
  // Additional fields and validation rules as defined in the physical data model
});

module.exports = mongoose.model('Example', exampleSchema);
```

### Model Sample
```javascript
// ExampleModel.js (Assuming a Node.js environment)
const mongoose = require('mongoose');

const ExampleSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  description: {
    type: String
  }
  // Define additional fields based on your physical data model
});

const ExampleModel = mongoose.model('Example', ExampleSchema);

module.exports = ExampleModel;
```

### Unit Test for Model
```javascript
// ExampleModel.test.js
const chai = require('chai');
const expect = chai.expect;
const ExampleModel = require('../models/ExampleModel');

describe('ExampleModel', () => {
  it('should be invalid if name is empty', (done) => {
    const m = new ExampleModel();

    m.validate((err) => {
      expect(err.errors.name).to.exist;
      done();
    });
  });

  // Additional unit tests to cover other scenarios
});
```
