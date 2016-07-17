# OpenNA
This is an application that provides information about lawmakers, bills and parties in Korea. Users can check not only the profile and activity of each lawmaker in their constituency, but also what kind of bills they propose and how the bills affects the lives of citizens.

# Features 

* Once the application launches, users can see a list of lawmaker's information with lawmakers' names and the parties they belong to. It lists all incumbent lawmakers who were elected during the 20th general election held in South Korea. On the right side of the list, there are indexes that enable users to find lawmakers easily based on the first letter of each lawmaker's family name. 

* If users tap the 'Bill' tab on the menu, they can see a list of bill information which is arranged in chronological order. Each card-like item listed contains the title of the bill, the names of the lawmakers who proposed the bill and which stage this bill is at in the National Assembly's legislation-making process. Moreover, the more they scroll through the list, the more bill information will become available. 

* The last tab on the menu, 'Party', displays a list of parties which have existed in South Korea from when the National Assembly was established back in 1948. When a party logo image is selected, the screen moves to the Wikipedia page for the selected party.

![Main](ScreenShot/Main_Lawmaker.PNG)![Main](ScreenShot/Main_Bill.PNG)![Main](ScreenShot/Main_Party.PNG)  

* When users select a lawmaker, they can see detailed information of the lawmaker which includes 'Birth', 'Party', 'In Office', 'District' and 'Homepage'. In addition, there is a button on the right side and if users push this button, the lawmaker information is saved and can be checked later in 'Favorites' menu on the bottom Tabbar menu. 

* Detailed information of the selected bill is also provided, as you can see the images below. It includes 'Assembly session', 'Proposed date', 'Status', 'Summary', and so on. If the 'External links' menu is tapped, the original bill document with pdf format is displayed so that users are able to see every detail of the bill. Bill information can also be saved by clicking the button on the top right of the screen.

* As I briefly stated above, party information is available when users can tap the logo image of the party.

![Detail](ScreenShot/Lawmaker_Detail.PNG)
![Detail](ScreenShot/Bill_Detail.PNG)
![Detail](ScreenShot/Party_Detail.PNG)

The images below show lists of lawmakers and bills that I saved based on my own interest. It is in this way, that users can save any information about lawmakers and bills that they are interested in and want to save.

![MyList](ScreenShot/Lawmaker_InList.PNG)
![MyList](ScreenShot/Bill_InList.PNG)

Finally, this application provides a 'Search' function, so that users are able to search lawmaker, bill and party information. In the top of the screen, users can type any search keyword they want and see the results of the search operation right away on the list below.

![Search](ScreenShot/Search_Result_Ahn.PNG)
![Search](ScreenShot/Search_Result_Park.PNG)


# Open Source Licence

This project uses open source library. Thanks for the developers who are dedicated to developing great open source library. 

*  [TeamPopong API](http://data.popong.com/)
*  [Alamofire](https://github.com/Alamofire/Alamofire)
*  [AlamofireImage](https://github.com/Alamofire/AlamofireImage)
*  [XCGLogger](https://github.com/DaveWoodCom/XCGLogger)
*  [MBProgressHUD](https://github.com/jdg/MBProgressHUD)

# Image Licence 

This project uses icons from Icons8. Thank [Icons8](https://icons8.com/) for your hard work. 

# How to build 

1) Clone the repository 

```
$ git clone https://github.com/woogii/OpenNA.git
$ cd OpenNA
```
2) Open the workspace in XCode 

```
$ open OpenNA.xcodeproj/
```
3) Set up the third party library 

```
$ pod install
```

4) Compile and run the app in your simulator 

# Compatibility 
The code of this project works in Swift2.2, Xcode 7.3 and iOS9 
