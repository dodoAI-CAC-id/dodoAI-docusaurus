---
id: service-dev-unittest
title: Service Dev & Unit Test
---

## Instruction
Develop the Service and its corresponding Unit Test.

## Overview
Service layer development focuses on implementing the business logic of an application, abstracting the code related to data access and manipulation from the Controller.

## Goals
To create services that fulfill the business logic requirements stipulated by the API Design and Swagger specifications.

## Sample
**Note: The following code samples are examples for instructional purposes. Use these formats as a guide and modify the content according to your specific service design requirements.**

### Service Sample (Node.js)
```javascript
// taskService.js
const dataAccess = require('./dataAccess'); // Data access layer abstraction

const updateTask = async (task_id, taskData) => {
  // Business logic to update a task
  const existingTask = await dataAccess.getTaskById(task_id);
  if (!existingTask) throw new Error('Task not found.');

  // Validate incoming task data...

  const updatedTask = await dataAccess.updateTask(task_id, taskData);
  return updatedTask;
};

module.exports = {
  updateTask,
};
```

### Unit Test for Service (using Jest)
```javascript
// taskService.test.js
const taskService = require('../services/taskService');
const dataAccess = require('../services/dataAccess');

jest.mock('../services/dataAccess');

describe('updateTask', () => {
  it('should call dataAccess.updateTask and return updated task', async () => {
    const task_id = '1';
    const taskData = { title: 'Updated Task Title' };
    const expectedTask = { ...taskData, task_id };

    dataAccess.getTaskById.mockResolvedValue({ task_id });
    dataAccess.updateTask.mockResolvedValue(expectedTask);

    const result = await taskService.updateTask(task_id, taskData);
    
    expect(dataAccess.getTaskById).toHaveBeenCalledWith(task_id);
    expect(dataAccess.updateTask).toHaveBeenCalledWith(task_id, taskData);
    expect(result).toEqual(expectedTask);
  });

  // Add more tests for scenarios like task not found or validation errors
});
```