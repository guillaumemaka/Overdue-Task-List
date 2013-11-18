#Section 6 

##OVERDUE ASSIGNMENT

###Objective:

Now that you have learned about the MVC design pattern and worked through the challenges, it’s time to put it all together. As you work through this assignment we recommend that you refer to previous code and lessons. Many portions of this assignment should be familiar. If you find yourself thinking that a method looks very similar, albeit with a different name, that’s a good thing!

Due to the complex nature of this project the requirements from time to time may seem to be a set of instructions. This is intentional as a way to hopefully limit frustration. If you would like to attempt this without any hints please read the brief below instead of the requirements. 

The instructions will be detailed at first but if a similiar problem reappears later in the assignment, expect the instructions to be shortened. For example when setting up a delegate for the first time we will be warned that a property named delegate is required. The second time we won’t warn you! 

When approaching this project, we STRONGLY recommend working on one part at a time.  As such, we have broken this assignment into multiple parts.

The solutions provided are not the only way to complete this assignment. You are highly encouraged to customize your application and attempt the problems on your own before viewing the solution videos. If your application meets the specified requirements, then you have solved that problem.  What is offered is concise and clean code that may prove to be a helpful comparison as you work through the assignment. 

As a final nudge in the right direction, watch the storyboard setup videos if you are unsure where to start after reading the requirements. The project requirements follow the solution videos so if you get stuck just watch the related solution video. You can also use the solutions videos to confirm you have correctly completed a requirement. It's good practice to check your code often and make sure we detect bugs early on. 

### Extra Credit

A quick foreward: I have attempted to organize the extra credit in order of difficulty. Everyone should be able to complete the first extra credit problem. From then on it will take some guile, hard work and research to solve the remaining problems. The list includes additional features and functionality to make your task list sparkle. Later when we cover data persistance with Parse you may even want to refactor your application to store tasks remotely. With some clean up, design and some creative features a task list may even be worth submitting to the app store. 

1. Personalize your application: Now that you know how to add UIImages and how to set background use them! Update view attributes, fonts, colors and more. Have fun and make your application sparkle.  

2. Display times along with the date for both the UITableViewCells and the DetailViewController dateLabel.

3. Add the option for the user to complete a task in both the DetailTaskViewController and EditTaskViewController. 

4. Implement multiple sections in the UITableView. Group all completed tasks, incomplete tasks and overdue tasks into 3 sections. This will be incredibly challenging and by no means required for completion of the iOS course! It may be worth circling back to once you have learned more about data persistence.

5. Add a setting page where users can choose alter the task list’s features. Examples of settings the user may have could include: viewing tasks alphabetically, capitalizing the first letter of the task automatically or inserting added tasks at the bottom or top of the task list. Any other settings you can dream up add here!

##Installation

Clone the project

	git clone https://github.com/guillaumemaka/Overdue-Task-List.git

Open the Xcode project and modify the following file

### **Overdue Task List-Prefix.pch**   

Replace the parse AppID and AppKey

	#define PARSE_APP_ID @"<Put your parse app id here>"
	#define PARSE_APP_CLIENT_KEY @">put your parse app key here>"
	
### **Overdue Task List-Info.plist**

1. Change FacebookAppID and FacebookAppDisplayName with your own (you can find them in your facebook developer dashboard)
2. Expand URL types and change the value of URL schemes to fb<your facebook app id> (ex: fb11241514135135345)

###Extra settings

If you want to run the app in your device you must set the Application iOS Native settings in your application settings on the facebook developer site.

You'll need to provide the Bundle ID and select enable for Login with facebook

![Illlustration](http://kosovich.org.ua/tmp/facebook_ios6_app_howto.png "Facebook setting")

