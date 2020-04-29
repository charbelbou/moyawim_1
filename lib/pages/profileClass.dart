import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:moyawim/pages/drawer.dart';
import 'package:moyawim/pages/globals.dart';
class ProfilePage
	{
		String userID;
		String fName;
		String lName;
		String bio;
		String location;
		
		String getName()
		{
			return fName + ' ' + lName;
		}
		String setFirstName(String firstname)
		{
			return fName = firstname;
		}
		String setLastName(String lastname)
		{
			return lName = firstname;
		}
		
		
		Map<String,dynamic> toJSON() =>
		{
			'firstname': fName,
			'lastname': lName,
			'location': location,
			'biography': bio,
		};
		
		ProfilePage(userID,fName,lName,location,bio)
		{
			this.userID = userID;
			this.fName = fName;
			this.lName = lName;
			this.location = location;
			this.bio = bio;
		}
	}