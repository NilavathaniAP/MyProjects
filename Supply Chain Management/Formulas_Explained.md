# Comprehensive Supply Chain Strategy for Ampicillin Delivery in Chennai 

## Project Overview

This project is dedicated to crafting a **cost-effective supply chain strategy** for the distribution of **Ampicillin** to the people of **Chennai**, ensuring that it is accessible to all socioeconomic classes. By addressing the intricacies of pharmaceutical distribution throughout, the goal is to optimize costs while maintaining high-quality healthcare standards.

The data for this project was collected from a local pharmacy, and the manufacturing data reflects this specific pharmacy's operations rather than company-wide data.

For an in-depth analysis and the development of the mathematical models used, please explore the details of my [project](https://drive.google.com/file/d/1o-VWM3CXqsH7KAjNRYN_PLMT2Md5Pbpi/view?usp=sharing).

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

Additionally, the project will soon expand to include:

🔸 **Retailer Management Analysis**: Investigating the role of retailers, this involves managing stock, forecasting demand,
 and optimizing supply chain operations to meet consumer needs. The goal is to enhance profitability and customer satisfaction
 by ensuring products are available when and where they are needed without incurring excess costs or inventory waste.

This project is a critical step toward ensuring that vital medications like Ampicillin reach every patient in need, through an optimized and data-driven supply chain.

Stay tuned for detailed analyses and future updates as this project progresses!
