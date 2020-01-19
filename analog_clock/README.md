# Dancing Clocks

## Geneses of the idea

I've eart about the challenge early in November 2019. I'm a fan of Dart and Flutter, but I first thought that
it was much more a challenge for designers. But my mother and father were both watch sellers (before they retired)
and I remembered when I was young and when I disassembled clocks: I was fascinated by the inner workings.

So let's participate and try to imagine the best clock ever!

In December 2019, I took most of the month to think about ideas. Here are some of them:
- glue clock: where drops falling from the sky make the figures magnify until they turn into another figure  
- mechanical clock: with cogs visible through transparency
- a water clock: a modern "Clepsydre" like the one you can visit at the [Noria Museum](https://fr.wikipedia.org/wiki/Clepsydre_moderne) in France 
- ...

All of these ideas where interesting, but a lot of design was required and the deadline of the challenge was too short to investigate.
I had to find something interesting but with no or few design requirement. And when thinking about the mechanical clock, I remembered **my own** history of clocks:

1968-1978: no clock (too young)
1978-1984: mechanical analog clocks
1985-1989: electronic digital clocks (7 segments)
1990-1998: electronic analog clocks
1999-2018: no clock
2019-now: clock with an embedded software which displays an analog clock or a digital clock

Did you see the pattern? mechanical analog -> electronic digital -> electronic analog -> software analog or digital

So what about a software which displays analog clocks which in turn form a digital time?
  
## Sketches


# Implementation

## Features

Each cycle of 1 minute, the time, the temperature (in Celsius or Fahrenheit) and the weather are displayed.

Between those displays, few animations are run. These animations are completely randomized: I personally want to stay in front 
to see what will be generated the next time.

I think that for a real clock used in the bedroom, the animations should be stopped between 10pm and 6pm. But I did
 not implemented for the challenge.

## Screenshot

## Video

## Bugs
- start of the app hangs sometimes 
- first animation with no time/temperature/weather for the first minute
x am/pm format
- size of the hand according to the density
- what if the total animation does not fill a minute?
- test performance in release mode
- change name in android?
