/*
    ABOUT: Storing Text
*/
-------------------------------------------------------------------------------


Use `TEXT` when you want to store a string value and you don't care about 
the length.

Use `VARCHAR(n)` when you want to set a limit for how long the string can be.

Use `text` For storing string data. 

The longest country name is:

The United Kingdom of Great Britain and Northern Ireland 

Which is 56 characters. 

So a country name column with a max length of 58 characters is reasonable

```sql
create table country_info (
    country_name varchar(58),
    capital_city TEXT
);
```

When inserting text values make sure to always use single qoutes.

The single qoutes do not count as part of the length.

```sql
insert into country_info (country_name, capital_city) 
values 
   ('italy', 'rome'),
   ('russia', 'moscow');
```
_______________________________________________________________________________
### The CHAR type

This is used when you want to store a currency symbol.

E.g. Japanese YEN = JPY

currency_symbol CHAR(3)

NOTE: Unlike VARCHAR which sets a max length, 
CHAR sets and exactly lenth. 

So if you try to insert a value that has less than 3 characters, it will fail.

_______________________________________________________________________________
