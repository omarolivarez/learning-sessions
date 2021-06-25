#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 24 21:05:13 2021

@author: OmarOlivarez
"""

"""
WHAT ARE VARIABLES?
-------------------
if x1 = 1
   x2 = 2
   x3 = 3
   
and
   y1 = 2
   y2 = 4
   y3 = 6
   
Can you describe the relationship between x and y? 

WHAT ARE FUNCTIONS?
-------------------
Well, y = 2x

Or, you might have also seen the notation: f(x) = 2x, where y = f(x). You read f(x) as 'ef of ex'.
Or, you'd say that 'y is a function of x'. 
So, y = f(x) = 2x.

In Python, you identify that something is a function by first writing the keyword 'def' in front of
the function name. This is how you would write: f(x) = 2x

def f(x): return 2x

A function intakes parameters inside the parenthes

Let's create more complex functions.
"""

"""
WHAT IS PANDAS?
---------------

"""
# function 1: a basic calculation
def calculate_birth_year(age):
    return 2021 - age

# FUNCTIONS
def main():
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("THE CODE BEGINS")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
    print()
    
    johns_age = 24 #yrs old
    janes_age = 64 #yrs old
    print("John's age is %d and his birth year is %d" % (johns_age, calculate_birth_year(johns_age)))
    print()
    print("Jane's age is %d and her birth year is %d" % (janes_age, calculate_birth_year(janes_age)))
    print()
    
    # now let's learn about other data types
    
    # VARIABLE DATA TYPES
    # strings
    print("String section")
    x = "Hello world!"
    print(type(x))
    
    # integers
    print("Integer section")
    x = 1
    print(type(x))
    
    # floats
    print("Float section")
    x = 1.02
    print(type(x))
    
    # booleans
    print("Boolean section")
    x = True 
    print(type(x))
    
    # COLLECTIONS
    
    # lists - ordered, changeable, and allows duplicates
    print("List section")
    x = [1, 2, 4, 2, 4]
    print(type(x))
    
    # sets - unordered, unchangeable, does not allow duplicates
    print("Set section")
    x = set(x)
    print(type(x))
    
    # tuples - ordered, unchangeable, and allows duplicates
    print("Tuple section")
    
    
    # dictionaries - ordered, changeable, does not allow duplicates
    print("Dictionary section")
    
    
    
main()






























