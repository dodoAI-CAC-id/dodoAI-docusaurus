---
id: controller-dev-unittest
title: Controller Dev & Unit Test
---

## Instruction
Write the program for the Controller and its Unit Test.

## Overview
Controller development involves creating the components that handle the request-response lifecycle in server-side applications.

## Goals
Ensure the Controller aligns with the specifications outlined in the API Design and Swagger documentation.

## Sample
**Note: The following examples are provided for formatting purposes. Customize the content according to the specifications of your Controller design.**

### Controller Sample (Node.js with Express)
```javascript
const express = require('express');
const router = express.Router();
const taskService = require('../services/taskService');

router.put('/tasks/:task_id', async (req, res) => {
  try {
    const { task_id } = req.params;
    const taskData = req.body;
    const updatedTask = await taskService.updateTask(task_id, taskData);
    res.status(200).json(updatedTask);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
```

### Unit Test for Controller (using Jest)
```javascript
const request = require('supertest');
const app = require('../app');
const taskService = require('../services/taskService');

// Mock the taskService's updateTask function
taskService.updateTask = jest.fn((task_id, taskData) => Promise.resolve({ ...taskData, task_id }));

describe('PUT /tasks/:task_id', () => {
  it('should update a task and return the updated task object', async () => {
    const taskData = { title: 'Updated Task', description: 'Updated Description' };
    const taskId = '1';
    
    const response = await request(app)
      .put(`/tasks/${taskId}`)
      .send(taskData);
    
    expect(response.statusCode).toBe(200);
    expect(response.body).toEqual(expect.objectContaining(taskData));
    expect(taskService.updateTask).toHaveBeenCalledWith(taskId, taskData);
  });

  // Add more tests for different scenarios (e.g., task not found, validation error)
});
```
