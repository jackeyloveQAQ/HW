1. What type would you choose for the following “numbers”?
A person’s telephone number
int
A person’s height
float
A person’s age
int
A person’s gender (Male, Female, Prefer Not To Answer)
bool
A person’s salary
int
A book’s ISBN
int
A book’s price
float
A book’s shipping weight
float
A country’s population
float
The number of stars in the universe
long
The number of employees in each of the small or medium businesses in the United Kingdom (up to about 50,000 employees per business)
int
2.What are the difference between value type and reference type variables? What is boxing and unboxing?
ref variable gives the address, value just copies the data
ref can change value in memory, value can't.
3. What is meant by the terms managed resource and unmanaged resource in .NET
The term "unmanaged resource" is usually used to describe something not directly under the control of the garbage collector.
4. Whats the purpose of Garbage Collector in .NET?
Manages the allocation and release of memory for your application.

1. What happens when you divide an int variable by 0?
throw an exception
2. What happens when you divide a double variable by 0?
Infinity 
3. What happens when you overflow an int variable, that is, set it to a value beyond its range?
Throw an error
4. What is the difference between x = y++; and x = ++y;?
x = y++:assign y to x then y plus 1
x = ++y:y plus 1 then assign y to x
5.What is the difference between break, continue, and return when used inside a loop statement?
break :jump out of loop
continue: jump out of this round and continue to next round loop
return: end the whole function
6. What are the three parts of a for statement and which of them are required?
initial, condition, operation after one round
7. What is the difference between the = and == operators?
= assign value
== equal or not
8. Does the following statement compile? 
for ( ; true; ) ;
yes , this means loop forever
9.What does the underscore _ represent in a switch expression? Defaults
replaces the default keyword to signify that it should match anything if reached
10. What interface must an object implement to be enumerated over by using the foreach statement?
IEnumerable interface

1. When to use String vs. StringBuilder in C# ?
stringbuilder can change the letter in specific position
string can't change
2. What is the base class for all arrays in C#?
The Array class
3.How do you sort an array in C#?
array.sort()
4.What property of an array object can be used to get the total number of elements in an array?
arr.Length
5. Can you store multiple data types in System.Array?
Yes you can specify object as its type.
6. What’s the difference between the System.Array.CopyTo() and System.Array.Clone()?
The Clone() method returns a new array (a shallow copy) object containing all the elements in the original array. 
The CopyTo() method copies the elements into another existing array.
