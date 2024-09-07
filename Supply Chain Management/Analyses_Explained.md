# Comprehensive Supply Chain Strategy for Ampicillin Delivery in Chennai 

For an in-depth analysis and the development of the mathematical models used, please explore the details of my [project](https://drive.google.com/file/d/1o-VWM3CXqsH7KAjNRYN_PLMT2Md5Pbpi/view?usp=sharing).

Overview on the topics and techniques used, is given in [Overview.md](https://github.com/NilavathaniAP/MyProjects/blob/main/Supply%20Chain%20Management/Overview.md)

### Key Analyses Conducted:

In Manufaturing Management,

🔹 **Break-Even Analysis**:  The break-even point *(BEP)* is the moment where
 revenue equals costs exactly. At this moment, neither a profit nor a loss has been made.
 Sales beyond that amount generate profit, while sales below that amount generate a loss. ***Recursive CTE*** techniques and VIEWs have been used to provide results for BEP.

The formula to calculate \( Q \) is:

$$
Q = \frac{F}{p - V}
$$

where Q - Quantity ; F - Fixed cost ; p - Selling price ; V - Variable cose

🔹 **Cumulative Work Hours**: Measuring the total labor required throughout the entire supply chain to ensure efficiency. 
Production work hours decrease by a certain percentage each time the quantity produced
 doubles. It is referred to as the cumulative average work hours model. In the project I used 90% progress rate, hence $$\phi$$ = 0.9.
 ***Optimised SQL techniques*** have been used instead of long rows of subqueris.
 
 The 
 formula to calculate the Cumulative work hours ($$T_n$$) is given by,

$$
\simeq \frac{K}{n+1}\left[(N+0.5)^{n+1}-(0.5)^{n+1}\right]
$$

where K - the number of direct
 labor hours required to produce the first unit ; n = $$\frac{log(\phi)}{log 2}$$ ; 

🔹 **Manufacturer Decision Models**:  It is crucial to ensure that pharmaceuticals and raw materials are always available and 
properly managed while keeping costs in check. Long-term storage of drugs can lead to waste, so manufacturing should begin at 
the optimal time to avoid excessive inventory and meet demand (D) efficiently. This model aids in determining the procurement 
levels and quantities that minimize overall costs. The level (L) when the manufacturing must begin, Quantity (Q) that has to manufactured 
and the Total minimum cost(TC) are given by 

$$
L = DT
$$

$$
Q=\sqrt{\frac{2C_pD}{C_h\left(1-\frac{D}{R}\right)}}
$$

$$
TC=\ C_iD\+\ \sqrt{2C_pC_hD\left(1-\frac{D}{R}\right)}
$$

where T - lead time in periods ; $$C_p$$ - procurement cost per procurement ; $$C_h$$ - holding cost per unit per period ; $$C_i$$ - tem cost per unit ; $$R$$ - replenishment rate in units per period

In Retailer Management,

🔸 **Replacement Analysis**:  It is critical to examine the drugs and
 replace those that have failed or become disoriented. We should also be aware that group
 replacements may be a smart choice to consider on occasion, as it reduces transportation
 costs or provides the shop with lower purchasing costs, as manufacturers frequently sell
 bulk products at a lower price than individual units. This part seeks to discover which day we have to 
 group that will provide us with the  lowest replacement cost.

 Since, $\ TC=UC+GC$

 $$UC\=\ \frac{C_u\displaystyle\sum^{t-1}x_t}{t}$$

 $$GC\=\\frac{C_gN_0}{t}$$

 $$TC_{min}=\ \frac{C_u\displaystyle\sum^{t-1}x_t}{t}\+\ \frac{C_gN_0}{t}$$

where $UC$ - Unit Cost, $C_u$ - unit cost replacement per unit, $GC$- Group Cost, $C_g$ - group cost replacement per unit, $TC$ - Total Cost

🔸 **Safety Stock Analysis**:  The goal of the safety stock is to compensate for demand and supply fluctuations. The
 assumption for service components planning is that the supply side is closely monitored
 in order to reduce deviations from planning to a minimum, and that supply-side uncer
tainty is low in comparison to demand-side uncertainty.

100 percent
 coverage would necessitate infinite safety stock, while 80-90 percent coverage is attainable
 and typical with acceptable safety stock.

 $$Safety \ Stock = C\sqrt{\mu_L\sigma_D^2+\mu_D^2\sigma_L^2}$$

 where $C$- normal inverse of the percentage of service level
