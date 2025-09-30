---
id: system-test
title: System Test
---

# System Test
## Guide to System Testing for dodo AI
### Introduction
System testing is a crucial phase in the development lifecycle of dodo AI, ensuring that the system functions end-to-end according to the requirements. This guide will provide a structured approach to perform system testing for dodo AI.
### Objectives
1. Validate the overall functionality of dodo AI.
2. Ensure the system meets specified requirements.
3. Identify and resolve defects before deployment.
### Test Planning
1. **Define Scope**: Outline features and components to be tested.
2. **Identify Test Cases**: Write detailed test cases covering all functionalities, including edge cases.
### Testing Process
#### 1. **Functional Testing**
##### **Base on user story list**: Test various conversation scenarios base on user story.
###### This is a sample:
| Classification          | #  | Story Name                    | Action                                 | Purpose                                                           |
|-------------------------|----|------------------------------|-----------------------------------------------------------------|--------------------------------------------------------------------------|
| Template Management     | 1  | Task search                   | Select category, enter keywords, click search button            | Search for tasks based on specific categories or keywords                |
| Template Management     | 2  | Add task                      | Click the "Add" button on the task list screen                  | Create new task                                                          |
| Template Management     | 3  | Edit task                     | Select the task you want to edit from the task list             | Transition to task content editing screen                                |
| Template Management     | 4  | Task information input        | Enter the task name, category, and associated project           | Edit task information                                                    |
| Template Management     | 5  | Add template                  | Press the [+] button on the task editing screen                 | Add templates associated with tasks                                      |
| Template Management     | 6  | Edit template                 | Enter template name and content                                 | Edit the contents of the template associated with the task               |
| Template Management     | 7  | Delete template               | Press the [×] button on the task editing screen                 | Delete templates associated with tasks                                   |
| Template Management     | 8  | Add image upload              | Press the image icon on the task editing screen                 | Add image upload function linked to tasks                                |
| Template Management     | 9  | Save task                     | Click the "Save" button on the task editing screen              | Save task information and associated templates                           |
| Template Management     | 10 | Delete task                   | Click the "Delete" button on the task editing screen            | Delete a task and its associated template                                |
| Project Management      | 11 | Project search                | Enter the project name or keyword and click the search button   | To find projects that match a specific project or search criteria       |
| Project Management      | 12 | Add project                   | Click the create new project button                             | To add a new project to the system                                       |
| Project Management      | 13 | Project details               | Select the project you want to edit                              | To check project details                                                 |
| Project Management      | 14 | Delete project                | Select the project you want and click the delete button         | To remove projects that are no longer needed from the system             |
| Project Management      | 15 | Add project members           | Click the Add button and select the member to add               | To add new members to the project                                        |
| Project Management      | 16 | Delete project member         | Select the member list and click the delete button              | To exclude members from a project                                        |
| Log Management          | 17 | View log list                 | Click the Log Management button in the menu                     | To view the list of logs                                                 |
| Log Management          | 18 | Project selection             | Select a project                                                | View logs based on a specific project                                    |
| Log Management          | 19 | Log filter                    | Select Project filter and user filter                           | To filter logs based on specific users                                   |
| Log Management          | 20 | log restoration               | Click on Thread ID for a specific log                           | To restore specific logs to the screen                                   |
| Authentication          | 21 | Google Authentication         | Using the login function                                        | Use Firebase Auth to log in with Google and features security            |
| Project selection       | 22 | Select project                | Utilize the project selection function                         | Be clear about the projects you work on and use dedicated tasks          |
| Category selection      | 23 | Select category               | Utilizing the category selection function                       | Select categories based on task to access tools and templates suits      |
| Framework selection     | 24 | Select framework              | Utilizing the framework selection function                      | Work effectively with the appropriate framework for your category        |
| Task selection          | 25 | Select task                   | Utilize the task selection function                            | Identify the tasks that best suit your work and utilize templates        |
| AI Code Generate        | 26 | Have an AI Chat               | Utilizing the AI ​​Chat execution function                      | Use AI to generate ideas and code to improve the quality of work         |
| AI Code Generate        | 27 | AI Chat with text             | Utilizing AI Chat + image execution function                    | Use text and images allows to get more intuitive & complex queries.      |
| AI Code Generate        | 28 | copy code                     | Using the copy function                                         | Easily maintain generated code, leading to more efficient work           |
| AI Code Generate        | 29 | Save code as file             | Utilize the save function                                       | Generated code can be saved as a file for later use or archiving         |
| AI Code Generate        | 30 | run code                      | Utilizing the execution function                                | You can test the generated code to see if it works correctly.            |
| Log View                | 31 | View list of logs             | Using the history viewing function                              | You can look back on your previous work by AI Chat history               |
| Log View                | 32 | Click to restore log          | Utilizing the log recovery function                             | You can effectively return to the previous state of AI Chat              |
| Feedback Management     | 33 | Task feedback input           | Enter your feedback on task detail and click Send button        | Register task-related feedback in the system                             |
| Feedback Management     | 34 | Non-task feedback input       | Enter your feedback on main feedback screen and click Send button   | Register non-task-related feedback in the system                        |
| Feedback Management     | 35 | Feedback display              | Select “Feedback” from the side menu                            | Display all feedback in descending order from the latest date and time  |
| Feedback Management     | 36 | Pagination                    | Click the next page button if 50 or more feedback                | Display past feedback sequentially                                       |
| User Management         | 37 | list display                  | Select "Management" from the menu                               | To view and manage a list of all users in the system                     |
| User Management         | 38 | User search                   | Enter your name and email address and click search button       | To quickly find a specific user                                          |
| User Management         | 39 | Add user                      | Click the "Add" button                                          | To add new users to the system                                           |
| User Management         | 40 | User edit                     | Select the user you want to edit and click the edit button      | To update user information                                               |
| User Management         | 41 | User information input        | Enter email, name, project, role                                | To enter user information accurately                                     |
| User Management         | 42 | User save                     | Click the "Save" button on the user edit screen                 | To save edited or newly created user information                         |
| User Management         | 43 | Delete user                   | Select the user you want to delete and click "Delete" button    | To remove users from the system when they are no longer needed           |
| User Management         | 44 | Confirm user details          | Click on the target user from the user list                      | To check detailed information of a specific user                         |
| User Management         | 45 | Edit user project             | Add or remove projects                                          | To update project information in which users are involved                |
| User Management         | 46 | Edit user role                | Add or remove roles                                             | To update a user's role                                                  |
| Authorization Service   | 47 | Create new role               | Create a role with a unique name and description                | To effectively define roles within the system                            |
| Authorization Service   | 48 | Defining permission           | Specify permissions (read, write, edit, delete) for role        | To control access actions based on roles                                 |
| Authorization Service   | 49 | Manage permission             | Establish and view a detailed list of privileges                | To ensure that all actions reflect permissions and can be managed       |
| Authorization Service   | 50 | Assign role to user           | Assign one or more roles to a user                              | To determine and manage user access rights based on role assignments     |
| Authorization Service   | 51 | ACL                           | Implement to enforce role permissions on resource               | To effectively enforce role-based access control to resources            |
| Authorization Service   | 52 | Verify access                 | Validate user resource access based on defined ACLs             | To ensure that access controls are in line with ACL definitions          |
| Authorization Service   | 53 | Role management               | Create, modify, and delete roles using an intuitive interface   | To simplify the role management process                                  |
| Authorization Service   | 54 | Role assignment               | Assign roles to users using the administrative interface        | To facilitate efficient role assignment                                  |
| Authorization Service   | 55 | Enforcing privilege           | Limit user actions based on assigned role privileges            | To maintain strict access controls within our systems                    |
| Authorization Service   | 56 | Error illegal                 | Appropriate error messages attempt invalid actions              | To provide feedback and prevent unauthorized operations                   |
| Authorization Service   | 57 | Implement audit logs          | Records all ID, actions taken, timestamps, and resources       | To audit role and permission changes for security and compliance         |
| Authorization Service   | 58 | Hierarchical support          | Allowing higher roles inherit permissions from lower roles      | To facilitate hierarchical role management                               |
| Authorization Service   | 59 | System scalability            | Enable the system to handle numbers of roles and privileges     | To maintain performance and availability as roles and users grow         |
| Authorization Service   | 60 | Resource Limits    | Set resource allocation limits for each role              | To prevent role overgrowth and control resource allocation. |
| Local Workspace         | 61 | File Access        | Access your local PC's workspace to edit files and folders| To manage files and folders in the workspace                |
| Local Workspace         | 62 | Workspace Settings | Configure and change workspace based requirements         | To allow set up the directory that best suits their environment |
| Local Workspace         | 63 | Execute Test Command | Run test commands using the command line interface      | To test the commands inside the workspace and the system works |
| Local Workspace         | 64 | Command Validation | Verify the safety and acceptable of a command before executing| To ensure that only safe and permissible commands are run   |
| Local Workspace         | 65 | Results and File   | Select result of test command and specified file          | To link test results and related files with AI and update   |
| Local Workspace         | 66 | File Sending Notification | Notify that a file has been updated by AI        | To enable you to check file update progress in real time    |
| Local Workspace         | 67 | Correction Files   | Receive modified files from AI                            | To check and apply automatic corrections made by AI         |
| Local Workspace         | 68 | Apply or Reject File | Check the contents of modified file, send Apply or Reject | To decide whether to reflect AI corrections if necessary    |
| Local Workspace         | 69 | Workspace Selection | Choose a workspace to work in                             | To clarify the directory and project you are working with   |
| Local Workspace         | 70 | Apply Correct File | If Apply is selected, the modified file will be overwritten | To reflect the modified contents in the file and maintain  |
| Local Workspace         | 71 | Security Transmission | Ensure secure transfer of data between local PC and AI  | To maintain data confidentiality and achieve secure communications |
##### **Base on functional requirement**: Test various conversation scenarios base on functional requirement
**User Management**
- Create User: Allow the creation of a new user and reflect this addition in the Auth-Service.
- Update User: Allow updates to existing user information and synchronize these updates with the Auth-Service.
- Delete User: Allow deletion of a user and ensure this deletion is reflected in the Auth-Service.
- Search User: Provide functionality to search and retrieve user information.
**Role Management**
- Obtain Roles from Auth-Service: Fetch roles information from the Auth-Service.
- Update Roles in Auth-Service: Update roles information in the Auth-Service.
**Data Synchronization with Auth-Service**
- Reflect User Additions in Auth-Service: Ensure that when user information is added, these additions are also reflected in the Auth-Service.
#### 2. **Usability Testing**
   - **Experience**: Test the interface (if applicable) for ease of use.
   - **Accessibility**: Ensure the system is accessible to s with disabilities.
   - **Error Messages**: Check if error messages are informative and helpful.
#### 3. **Integration Testing**
   - **API Endpoints**: Verify that all API integrations work seamlessly.
   - **Database**: Ensure that the database operations (insert, update, delete) are functioning correctly.
----------------
