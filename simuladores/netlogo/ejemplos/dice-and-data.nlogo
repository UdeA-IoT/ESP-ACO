globals 
[
  num-dice
  observed-frequency
  grand-total
  pmf
  standard-dev
  plot-theoretical?
  max-theoretical-probability
  degrees-of-freedom
  chi-squared
  total-roll
  rolls-plotted
]

breed [dice]

dice-own 
[
  spots
]

to startup
  setup
end

to setup
  clear-all
  setup-globals
  setup-dice
  reset-ticks
  setup-plot
end

to setup-globals
  set num-dice number-of-dice
  set observed-frequency (n-values (5 * num-dice + 1) [0])
  set grand-total 0
  set pmf theoretical-pmf num-dice
  set standard-dev (sqrt (num-dice * 35 / 12))
  set max-theoretical-probability (max pmf)
  set plot-theoretical? show-theoretical?
  set degrees-of-freedom (5 * num-dice)
end

to setup-dice
  set-default-shape dice "die-1"
  create-dice num-dice 
  [
    set xcor who
    set color white
    roll-one
  ]
end

to setup-plot
  set-plot-x-range (num-dice - 0.5) (0.5 + number-of-dice * 6)
  set-plot-y-range 0 ((ceiling (100 * max-theoretical-probability)) / 100)
  if plot-theoretical? 
  [
    plot-theoretical-distribution
    plot-moments
  ]
end

to go
  roll
  tick
end

to roll
  ask dice 
  [
    roll-one
  ]
  update-observations (sum [spots] of dice)
end

to roll-one
  set spots (1 + random 6)
  set shape (word "die-" spots)
end

to update-observations [value]
  let head (sublist observed-frequency 0 (value - num-dice + 1))
  let tail 
      (sublist observed-frequency (value - num-dice + 1) (5 * num-dice + 1))
  let new-frequency (1 + last head)
  set observed-frequency (sentence (butlast head) new-frequency tail)
  set total-roll value
  set grand-total (grand-total + value)
end

to update-plot-range
  let peak-count (max observed-frequency)
  let y-limit (max (list max-theoretical-probability (peak-count / ticks)))
  set-plot-y-range 0 ((ceiling (50 * y-limit)) / 50)
end

to update-plot-average
  let average (grand-total / ticks)
  set-current-plot-pen "average"
  plot-pen-reset
  plotxy average -0.1
  plotxy average 1
end

to update-histogram
  set-current-plot-pen "observed"
  plot-pen-reset
  (foreach (n-values (5 * num-dice + 1) [num-dice + ?]) observed-frequency 
    [
      plotxy (?1 - 0.5) (?2 / ticks)
    ]
  )
  set rolls-plotted ticks
end

to update-plot
  if (ticks > 0) 
  [
    set-current-plot "Relative Frequencies"
    update-plot-range
    update-plot-average
    update-histogram
    update-statistics
  ]
end

to update-statistics
  set chi-squared 
    (sum (map [(?1 * ?1) / (?2 * ticks)] observed-frequency pmf) - ticks)
end

to plot-theoretical-distribution
  set-current-plot "Relative Frequencies"
  set-current-plot-pen "pmf"
  plot-pen-reset
  (foreach (n-values (5 * num-dice + 1) [num-dice + ?]) pmf 
    [
      plotxy (?1 - 0.5) ?2
      plotxy (?1 + 0.5) ?2
    ]
  )
end

to clear-theoretical-distribution
  set-current-plot-pen "pmf"
  plot-pen-reset
end

to plot-moments
  set-current-plot-pen "moments"
  plot-pen-reset
  plotxy (3.5 * num-dice - standard-dev) -0.1
  plotxy (3.5 * num-dice - standard-dev) 1
  plotxy (3.5 * num-dice) 1
  plotxy (3.5 * num-dice) -0.1
  plotxy (3.5 * num-dice + standard-dev) -0.1
  plotxy (3.5 * num-dice + standard-dev) 1
end

to clear-moments
  set-current-plot-pen "moments"
  plot-pen-reset
end

to-report theoretical-pmf [n]
  let result []
  let possible-values (5 * n + 1)
  let set-cardinality (6 ^ n)
  foreach (n-values (ceiling (possible-values / 2)) [?]) 
  [
    let event-cardinality (combinations n (n + ?))
    set result (lput (event-cardinality / set-cardinality) result)
  ]
  set result (sentence result reverse 
    ifelse-value ((possible-values mod 2) = 1) [but-last result] [result])
  report result
end

to-report combinations [n x]
  report enumerate n x []
end
 
to-report enumerate [n x dice-list]
  let result 0
  ifelse ((length dice-list) = n) 
  [
    set result (factorial n)
    foreach (remove-duplicates dice-list) 
    [
      let current-value ?
      let occurrences (length (filter [? = current-value] dice-list))
      if (occurrences > 1) 
      [
        set result (result / factorial occurrences)
      ]
    ]
  ]
  [
    let dice-remaining (n - (length dice-list))
    let running-sum (sum dice-list)
    let max-possible (min (list 
        (ifelse-value (empty? dice-list) [6] [last dice-list]) 
        (x - running-sum - dice-remaining + 1)))
    let min-possible 
        (max (list 1 (ceiling ((x - running-sum) / dice-remaining))))
    if (max-possible >= min-possible) 
    [
      foreach (n-values (max-possible - min-possible + 1) [max-possible - ?]) 
      [
        set result (result + enumerate n x lput ? dice-list)
      ]
    ]
  ]
  report result
end
 
to-report factorial [n]
  let product 1
  foreach (n-values n [1 + ?]) 
  [
    set product (product * ?)
  ]
  report product
end

to-report plot-daemon?
  let result? false
  if (show-theoretical? xor plot-theoretical?) 
  [
    set plot-theoretical? show-theoretical?
    ifelse (plot-theoretical?) 
    [
      plot-theoretical-distribution
      plot-moments
      set result? true
    ]
    [
      clear-theoretical-distribution
      clear-moments
    ]
  ]
  if (ticks > rolls-plotted) 
  [
    update-plot
    set result? true
  ]
  report result?
end

;; Copyright (c) 2013, Nicholas Bennett. All rights reserved. 
;; For more informationon on permitted uses, see the Information tab.
@#$#@#$#@
GRAPHICS-WINDOW
10
10
740
101
-1
0
60.0
1
10
1
1
1
0
1
1
1
0
11
0
0
1
1
1
Rolls
30.0

SLIDER
10
110
160
143
number-of-dice
number-of-dice
1
12
1
1
1
NIL
HORIZONTAL

MONITOR
190
290
265
335
NIL
plot-daemon?
17
1
11

BUTTON
35
270
135
303
Roll Forever!
go
T
1
T
OBSERVER
NIL
R
NIL
NIL
0

BUTTON
35
150
135
184
Setup
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

SWITCH
10
310
160
343
show-theoretical?
show-theoretical?
1
1
-1000

BUTTON
35
190
135
223
Roll Once
go
NIL
1
T
OBSERVER
NIL
O
NIL
NIL
0

BUTTON
35
230
135
263
Roll 100
repeat 100 [\n  go\n]
NIL
1
T
OBSERVER
NIL
1
NIL
NIL
0

PLOT
170
110
740
345
Relative Frequencies
NIL
NIL
0.0
10.0
0.0
10.0
false
false
"" ""
PENS
"pmf" 1.0 0 -2382653 true "" ""
"moments" 1.0 0 -6759204 true "" ""
"average" 1.0 0 -4539718 true "" ""
"observed" 1.0 1 -16777216 true "" ""

MONITOR
680
110
740
155
Average
ifelse-value (ticks > 0) \n  [grand-total / ticks]\n  [\"N/A\"]
3
1
11

@#$#@#$#@
## WHAT IS IT?

This model repeatedly rolls 1 to 12 dice, computes the sum, and displays a histogram of the empirical distribution of the resulting values. Optionally, it also displays the theoretical distribution of the values.

## HOW IT WORKS

This is a very simple Monte Carlo simulation (an experimental method where random or pseudorandom numbers are generated and used to simulate a process with a high degree of randomness). Here, each trial consists of generating one or more uniform discrete pseudorandom variables, from the set {1, 2, 3, 4, 5, 6} &ndash; i.e. modeling the roll of dice &ndash; and summing them. This process is illustrated by creating one agent per die, and dynamically changing the die shape, based on the random number generated. After each trial, the result is used to update a tally &ndash; which is in turn used to construct a histogram of relative frequencies.

## HOW TO USE IT

Use the controls to configure and run the simulation as follows.

* The **number-of-dice** slider controls the number of six-sided dice used in each roll.

* The **Setup** button creates agents for the dice display, resets the cell counts used for the histogram, and clears the plot.

* **Roll Once** executes a single roll of the dice.

* The **Roll 100** button rolls the dice 100 times.

* The **Roll Forever!** button rolls repeatedly until the user presses the button again. As it does so, the **Relative Frequencies** plot is automatically updated periodically.

* **show-theoretical?** toggles the display of the probability mass function (PMF) of the theoretical distribution, and the &mu; and &mu; &plusmn; &sigma; lines in the **Relative Frequencies** plot (see below).

The **Average** monitor displays the current average value, computed across all the rolls (since the last time **Setup** was clicked).

The **Relative Frequencies** plot includes the following data.

* The relative frequency observed for each value is plotted in black as a histogram.

* The sample mean (average) of the observed values is shown with a gray vertical line.

Optionally (using the **show-theoretical?** switch), additional information is displayed in **Relative Frequencies**:

* The probability mass function (the theoretical relative frequencies for the dice totals) is shown in magenta, as the upper outline of a histogram.

* &mu; (the mean, or theoretical average) and &mu; &plusmn; &sigma; (the mean plus or minus one standard deviation) are displayed with cyan vertical lines.

(In the histogram of relative frequencies, each bar begins at the relevant value, less 0.5; for example, with 1 die, the first bar start at an X value of 0.5 and ends at an X value of 1.5. This doesn't follow the standard convention for frequency histograms for quantitative sample values &ndash; in which each bar begins with the smallest value in the interval &ndash; but it can be less confusing to the casual user.)

## THINGS TO NOTICE

With a single die, the histogram of dice rolls becomes roughly flat, after a large number of rolls. However, with two or more dice, that's no longer the case. Why not? 

Examining the possible values produced by the sum of two dice shows us that even though each of the numbers 1-6 is equally likely on a single die, the sums 2-12 obtained from a pair of dice aren't equally likely.

<table style="width: 280px; border-spacing: 0">
    <thead>
        <tr>
            <td colspan="2" style="width: 100px">&nbsp;</td>
            <td colspan="6" style="text-align: center; width: 180px; font-weight: bold">Die #2</td>
        </tr>
        <tr>
            <td style="width: 60px">&nbsp;</td>
            <td style="width: 40px; text-align: center; font-style: italic; border-bottom: 1px solid black; border-right: 1px solid black">(1 + 2)</td>
            <td style="text-align: center; border-bottom: 1px solid black; width: 30px; font-weight: bold">1</td>
            <td style="text-align: center; border-bottom: 1px solid black; width: 30px; font-weight: bold">2</td>
            <td style="text-align: center; border-bottom: 1px solid black; width: 30px; font-weight: bold">3</td>
            <td style="text-align: center; border-bottom: 1px solid black; width: 30px; font-weight: bold">4</td>
            <td style="text-align: center; border-bottom: 1px solid black; width: 30px; font-weight: bold">5</td>
            <td style="text-align: center; border-bottom: 1px solid black; width: 30px; font-weight: bold">6</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="6" style="text-align: right; font-weight: bold">Die #1</th>
            <td style="text-align: center; border-right: 1px solid black; font-weight: bold">1</td>
            <td style="text-align: center">2</td>
            <td style="text-align: center">3</td>
            <td style="text-align: center">4</td>
            <td style="text-align: center">5</td>
            <td style="text-align: center">6</td>
            <td style="text-align: center">7</td>
        </tr>
        <tr>
            <td style="text-align: center; border-right: 1px solid black; font-weight: bold">2</td>
            <td style="text-align: center">3</td>
            <td style="text-align: center">4</td>
            <td style="text-align: center">5</td>
            <td style="text-align: center">6</td>
            <td style="text-align: center">7</td>
            <td style="text-align: center">8</td>
        </tr>
        <tr>
            <td style="text-align: center; border-right: 1px solid black; font-weight: bold">3</td>
            <td style="text-align: center">4</td>
            <td style="text-align: center">5</td>
            <td style="text-align: center">6</td>
            <td style="text-align: center">7</td>
            <td style="text-align: center">8</td>
            <td style="text-align: center">9</td>
        </tr>
        <tr>
            <td style="text-align: center; border-right: 1px solid black; font-weight: bold">4</td>
            <td style="text-align: center">5</td>
            <td style="text-align: center">6</td>
            <td style="text-align: center">7</td>
            <td style="text-align: center">8</td>
            <td style="text-align: center">9</td>
            <td style="text-align: center">10</td>
        </tr>
        <tr>
            <td style="text-align: center; border-right: 1px solid black; font-weight: bold">5</td>
            <td style="text-align: center">6</td>
            <td style="text-align: center">7</td>
            <td style="text-align: center">8</td>
            <td style="text-align: center">9</td>
            <td style="text-align: center">10</td>
            <td style="text-align: center">11</td>
        </tr>
        <tr>
            <td style="text-align: center; border-right: 1px solid black; font-weight: bold">6</td>
            <td style="text-align: center">7</td>
            <td style="text-align: center">8</td>
            <td style="text-align: center">9</td>
            <td style="text-align: center">10</td>
            <td style="text-align: center">11</td>
            <td style="text-align: center">12</td>
        </tr>
    </tbody>
</table>

As the table above shows, there are 36 different combinations of rolls obtained with a pair of dice, and some combinations give the same sum as other combinations. The proportion of occurrence of a given sum in the table corresponds to its long-term frequency of occurrence in the actual dice rolls. For example, 6 of the 36 combinations result in a sum of 7, while only 1 of the 36 gives a sum of 12. Thus, over a large number of rolls, we should expect a sum of 7 to appear approximately 6/36<sup>ths</sup>, or 1/6<sup>th</sup> of the time; on the other hand, 12 should only appear about 1/36<sup>th</sup> of the time.

As the number of dice increases further, the histogram of relative frequencies becomes more tightly grouped around the average value, which also tends to be very close to the midpoint of the range of possible values. This is seen especially clearly when **show-theoretical?** is selected: as the number of dice increase, the band of possible values between the standard deviation lines is a smaller fraction of the total range of possible values. Notice also that the line showing the average of the observed values moves closer and closer to the line for the mean, as the number of rolls increases.

Both of the above are examples of the phenomenon first described mathematically by Bernoulli, then called the "law of large numbers" by Poisson. The law of large numbers is a theorem showing that the sample mean converges to the true mean as the sample size goes to infinity, regardless of the underlying distribution.

You might also notice that the histograms of observed and theoretical relative frequencies become more and more bell-shaped, as the number of dice increases. This phenomenon is explained by the "central limit theorem," originally stated by de Moivre, refined significantly by Laplace, and rigorously generalized by Lyapunov. (The "central limit" name was first applied by Polya.) This theorem shows that the distribution of the sum (or average) of independent, identically distributed random values, with finite mean and variance, converges to the normal distribution.

The law of large numbers and the central limit theorem are the first two fundamental theorems of probability and statistics.

## THINGS TO TRY

To get a taste of how the computational capabilities of modern computers have revolutionized Monte Carlo methods, turn the **view updates** checkbox off, and click the **Run Forever!** button, to run experiments as fast as possible. Depending on the processing speed of your computer, the model should be able to roll the dice hundreds of thousands &ndash; even millions &ndash; of times within a minute or two. Imagine trying to perform the same number of trials by hand &ndash; or even with the primitive computing facilities available to the scientists working at Los Alamos National Laboratory in the 1940s. (Monte Carlo methods were first used in the Manhattan Project, and were subsequently studied and extended at LANL and elsewhere.) 

Of course, real-world Monte Carlo simulations are rarely as simple as this one, but the increase in computing power has had a dramatic impact across the spectrum of model types and magnitudes.

## EXTENDING THE MODEL

The model could easily be extended to include a Pearson's chi-squared goodness of fit test, for use by students studying statistical hypothesis testing. In that case, the null hypothesis would be that the generated outcomes are distributed according to the relevant theoretical distributions. (In fact, the model already declares and updates two global variables, `chi-squared` and `degrees-of-freedom`, that could be used for this purpose.)

## NETLOGO FEATURES

Although the histogram primitive can plot a histogram from a list of data with minimal code, performance degrades as the list of data gets longer and longer. For that reason, this model keeps a list of cell counts, instead of the raw data, and it uses plotxy to construct the histogram (as well as the other plotted displays) explicitly. This results in constant plotting performance, even after millions of trials.

For performance reasons, plotting isn't driven by the NetLogo v5+ tick-based `update-plots` mechanism, and thus isn't automatically updated on every tick. Instead, it's driven by a hidden monitor (located under the **Relative Frequencies** plot) that displays the value of a reporter procedure. That reporter procedure checks to see if the plot needs to be updated (i.e. if the number of ticks is higher than the number of rolls plotted), and does so if necessary. This means that at high speed, several ticks (sometimes thousands) can go by between plot updates, but the updates still occur often enough to appear smooth. 

Monitoring the **show-theoretical?** switch (which is done even when the dice aren't being rolled) is done with the same hidden monitor and reporter procedure. That procedure watches for changes in the switch value and updates the plot accordingly. 

For some models, this monitor-driven behavior is a useful technique for implementing d&aelig;mons that run asynchronously to the main simulation loop (e.g. a forever button) &ndash; and that can even run when no button is pressed.

## RELATED MODELS AND ACTIVITIES

This model was inspired in part by the Project GUTS "Dice & Data" activity, in which students form pairs and roll one die and then two dice, tallying the outcomes in each case. These tallies are aggregated and used to construct histograms, illustrating the effect on central tendency produced by summing random variables.

The "Dice Stalagmite" model in the standard NetLogo models library is somewhat similar to this one, in that histograms are drawn for one- and two-dice rolls. However, the emphasis in that model is on using animation to construct the histograms, rather than comparing the observed and theoretical distributions over a large number of trials; it is also limited to rolls of two dice. (No code from the "Dice Stalagmite" model is used in this model.)

## REFERENCES

Mlodinow, L. _The Drunkard's Walk: How Randomness Rules Our Lives_. Random House Inc., New York, NY, 2009.

Boslaugh, S. and Watters, P. A. _Statistics in a Nutshell_. O'Reilly Media, Inc., Sebasopol, CA, 2008.

"Central limit theorem". http://en.wikipedia.org/wiki/Central_limit_theorem. Wikipedia, Dec. 2012. (Accessed: 26 Jan. 2013.)

"Law of large numbers". http://en.wikipedia.org/wiki/Law_of_large_numbers. Wikipedia, Jan. 2013. (Accessed: 26 Jan. 2013.)

"Monte carlo method". http://en.wikipedia.org/wiki/Monte_Carlo_method. Wikipedia, Jan. 2013. (Accessed: 26 Jan. 2013.)

Lee, I. "Dice & Data to Random Walks". http://www.projectguts.org/files/D1-Dice&Data_0.doc. Project GUTS, 2010. (Accessed: 28 Oct. 2010.)

Abrahamson, D. and Wilensky, U. NetLogo Dice Stalagmite model. http://ccl.northwestern.edu/netlogo/models/DiceStalagmite. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL, 2005.

## COPYRIGHT

Copyright &copy; 2013, Nicholas Bennett.  
All rights reserved. 

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.  
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY NICHOLAS BENNETT "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL NICHOLAS BENNETT BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


## ACKNOWLEDGEMENTS

Development of this model was funded in part by [Project GUTS](http://www.projectguts.org) and the [Santa Fe Alliance for Science](http://www.sfafs.org/). As noted above, the concepts of this model were inspired in part by the Project GUTS "Dice & Data" activity.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

die-1
false
0
Rectangle -7500403 true true 15 60 285 240
Rectangle -7500403 true true 60 15 240 285
Circle -7500403 true true 15 15 88
Circle -7500403 true true 195 15 90
Circle -7500403 true true 15 195 90
Circle -7500403 true true 195 195 90
Circle -16777216 true false 120 120 60

die-2
false
0
Rectangle -7500403 true true 15 60 285 240
Rectangle -7500403 true true 60 15 240 285
Circle -7500403 true true 15 15 88
Circle -7500403 true true 195 15 90
Circle -7500403 true true 15 195 90
Circle -7500403 true true 195 195 90
Circle -16777216 true false 195 45 60
Circle -16777216 true false 45 195 60

die-3
false
0
Rectangle -7500403 true true 15 60 285 240
Rectangle -7500403 true true 60 15 240 285
Circle -7500403 true true 15 15 88
Circle -7500403 true true 195 15 90
Circle -7500403 true true 15 195 90
Circle -7500403 true true 195 195 90
Circle -16777216 true false 195 195 60
Circle -16777216 true false 45 45 60
Circle -16777216 true false 120 120 60

die-4
false
0
Rectangle -7500403 true true 15 60 285 240
Rectangle -7500403 true true 60 15 240 285
Circle -7500403 true true 15 15 88
Circle -7500403 true true 195 15 90
Circle -7500403 true true 15 195 90
Circle -7500403 true true 195 195 90
Circle -16777216 true false 195 195 60
Circle -16777216 true false 45 45 60
Circle -16777216 true false 45 195 60
Circle -16777216 true false 195 45 60

die-5
false
0
Rectangle -7500403 true true 15 60 285 240
Rectangle -7500403 true true 60 15 240 285
Circle -7500403 true true 15 15 88
Circle -7500403 true true 195 15 90
Circle -7500403 true true 15 195 90
Circle -7500403 true true 195 195 90
Circle -16777216 true false 195 195 60
Circle -16777216 true false 45 45 60
Circle -16777216 true false 45 195 60
Circle -16777216 true false 195 45 60
Circle -16777216 true false 120 120 60

die-6
false
0
Rectangle -7500403 true true 15 60 285 240
Rectangle -7500403 true true 60 15 240 285
Circle -7500403 true true 15 15 88
Circle -7500403 true true 195 15 90
Circle -7500403 true true 15 195 90
Circle -7500403 true true 195 195 90
Circle -16777216 true false 195 195 60
Circle -16777216 true false 45 45 60
Circle -16777216 true false 45 195 60
Circle -16777216 true false 195 45 60
Circle -16777216 true false 45 120 60
Circle -16777216 true false 195 120 60

dot
false
0
Circle -7500403 true true 90 90 120

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

@#$#@#$#@
NetLogo 5.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 1.0 0.0
0.0 1 1.0 0.0
0.2 0 1.0 0.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
1
@#$#@#$#@
