<div>

<span class="c4"> </span>

</div>

# <span class="c5">Assignment 7 IT FDN 130 A</span>

<span class="c4">Written by Steven Michalove</span>

<span class="c4">Date: Aug, 22 2021</span>

<span class="c4"></span>

# <span class="c5">Introduction</span>

<span class="c4">Here we discuss when to use a user defined function .  It discusses the likeness of an Inline function to a view. As well as the difference between function types.</span>

# <span class="c13">When you would use a SQL UDF</span>

<span class="c4"></span>

<span class="c4">A User Defined Function (UDF) is used to use SQL logic programming complex procedures that can read, write, or compute one or more values.  Unlike views they can accept input from the user in the form of a parameter and optionally write results back to the database.  They offer repeatability and can be called one or more times.</span>

<span class="c4"></span>

<span class="c4"></span>

# <span class="c13">Differences between Scalar, Inline, and Multi-Statement Functions</span>

<span class="c4"></span>

<span>A scalar function can accept input from the user in the form of a parameter but only return a single value back.  Inline functions can, unlike scalar functions produce tables of values in the form of rows and columns and generate results from parameters. Unlike Inline functions, multi-Statement functions can also return table values with the addition of statistical or aggregate calculations. Multi-statement functions can write changes to the database.  Inline functions create views (output) of table based data based upon the parameter  specified by the user. All these functions can support one or more parameters as input by the user.</span> <sup class="c1">[[1]](#ftnt1)</sup><span>  Inline Functions have better performance than multi-statement functions.</span><sup class="c1">[[2]](#ftnt2)</sup>

<span class="c4"></span>

# <span class="c5">Conclusion</span>

<span class="c4">This paper discussed when to use functions and the difference between different function types.</span>

* * *

<div>

[[1]](#ftnt_ref1)<span class="c0"> https://www.quora.com/What-is-difference-between-inline-table-valued-and-multi-statement-functions-in-SQL</span>

</div>

<div>

[[2]](#ftnt_ref2)<span class="c0"> </span><span class="c11">[https://stackoverflow.com/questions/2554333/multi-statement-table-valued-function-vs-inline-table-valued-function](https://www.google.com/url?q=https://stackoverflow.com/questions/2554333/multi-statement-table-valued-function-vs-inline-table-valued-function&sa=D&source=editors&ust=1629663159473000&usg=AOvVaw1HBvsFqS_OUBaIakby3phE)</span>

<span class="c0"></span>



</div>