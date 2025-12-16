Airbnb Pricing Analysis in Major European Cities
================
Hill Zhang
2024-05-05

- [Project Summary](#project-summary)
- [Reproducibility](#reproducibility)
- [Introduction](#introduction)
- [Data](#data)
- [Ethical considerations](#ethical-considerations)
- [Data import](#data-import)
- [Data cleaning](#data-cleaning)
- [Analysis](#analysis)
- [Conclusions and next steps](#conclusions-and-next-steps)

``` r
library(tidyverse)
library(ggplot2)
#install.packages("ggiraphExtra")
#library(ggiraphExtra)
library(modelr)
options(na.action = na.warn)

data_dir <- if (dir.exists('data/raw')) 'data/raw' else '.'
```

## Project Summary

- **Goal:** quantify what drives Airbnb listing prices across major
  European cities, and compare weekday vs weekend pricing.
- **Data:** Kaggle dataset *Airbnb Prices in European Cities* (20 CSV
  files, 10 cities, weekdays vs weekends).
- **Methods:** data cleaning + exploratory analysis
  (distribution/outliers), then linear regression and log-linear
  regression with basic residual checks.
- **Key takeaways (high level):**
  - **Room type** is a strong predictor. Entire homes tend to price
    higher than private or shared rooms.
  - **Location matters.** Listings closer to city centers and metro
    stations tend to price higher.
  - **Weekday vs weekend** price differences are small in this dataset.
  - **Log-transforming price** improves fit for skewed price
    distributions with outliers.

## Reproducibility

1.  Download the dataset from Kaggle (linked below) and place the CSVs
    in a folder such as `data/raw/`.
2.  Update the `read_csv()` paths in the Data import section if needed.
3.  Knit this R Markdown file to HTML (or render to GitHub Markdown).

## Introduction

This project explores the complex dynamics of Airbnb pricing across
major European cities, aiming to understand the factors influencing
listing prices on this popular accommodation-sharing platform. The
analysis examines how various attributes such as room type, host status,
and location factors individually and collectively affect prices. The
investigation is structured around four key questions. The first three
questions focus on the relationship between individual factors and
listing prices, exploring the influence of day types (weekdays or
weekends), room types (entire home, private room, and shared rooms), and
location. The final question examines how these attributes collectively
impact the listing price through modeling.

The analysis provides multiple crucial findings. Room type serves as a
significant predictor of pricing, with entire homes generally commanding
higher prices than private or shared rooms. Proximity to city centers
and metro stations also significantly influenced prices, with listings
closer to these hubs demanding higher rates. Interestingly, prices did
not vary significantly between weekdays and weekends, which contradicts
common expectations. Additionally, the use of a log-transformed linear
regression model emphasized the importance of transforming skewed data
to enhance model fit and interpretability. This model was particularly
effective, explaining a significant portion of the variability in prices
and outperforming the standard linear model. The insights from this
study offer valuable guidance several different groups: 1. travelers
seeking for better pricing; 2. hosts looking to optimize their pricing
strategies; 3. policymakers aiming to understand the impact of various
factors on local accommodation markets.

## Data

The dataset for the project “Determinants of Airbnb Prices in European
Cities” is obtained from the supplementary materials provided by Kristóf
Gyódi and Łukasz Nawaro for their research article published in Tourism
Management. Their article, “Determinants of Airbnb Prices in European
Cities: A Spatial Econometrics Approach,” employs spatial regression
models to uncover factors that influence Airbnb pricing across major
European cities. This extensive dataset includes data for both weekday
and weekend listings and encompasses a variety of attributes such as
accommodation type, room privacy, capacity, superhost status, and
cleanliness ratings. Additionally, it contains geographic details like
proximity to city centers and metro stations. The data was evenly
collected to facilitate a detailed spatial econometric analysis aimed at
unraveling the complex pricing dynamics within the Airbnb market.

The authors have meticulously documented the dataset, ensuring each
entry is enriched with attributes essential for a multi-dimensional
analysis. Although the dataset provides comprehensive information on
pricing and property characteristics, it lacks temporal context, which
could elucidate market trends over time. Integrating data on the timing
of collection could enable the analysis of seasonal or annual variations
in pricing strategies and guest preferences. The complete dataset is
publicly available on Kaggle under the URL
<https://www.kaggle.com/datasets/thedevastator/airbnb-prices-in-european-cities/data>,
ensuring the transparency and reproducibility of the research findings.

## Ethical considerations

Utilizing the “Determinants of Airbnb Prices in European Cities” dataset
brings to light several ethical considerations. First, regarding privacy
concerns, the dataset includes detailed information about Airbnb
listings, such as geographical coordinates and the host’s ‘superhost’
status. It is vital to ensure that no individual host or property is
identifiable from the dataset to maintain security and privacy.

Second, the analysis of Airbnb pricing and its determinants can have
broader socio-economic impacts. For example, insights from this study
could influence Airbnb’s pricing strategies or guide regulatory actions
by local governments. If employed responsibly, this data can promote
fair pricing practices and help cities manage the impact of short-term
rentals on local housing markets. Conversely, if misused, this data
could manipulate market prices or exacerbate housing shortages.

Lastly, the potential misuse of this dataset by third parties for
purposes not originally intended, such as targeting specific
demographics or neighborhoods for commercial benefits, presents ethical
challenges. It is imperative to acknowledge these implications and
ensure that any analysis or dissemination of findings is conducted
transparently and adheres to ethical standards, aiming to positively
influence the communities impacted by the data.

## Data import

The initial step in our analysis involves importing the dataset for
Airbnb prices across several major European cities. The dataset is
structured to provide separate files for each city that detail Airbnb
pricing information for both weekdays and weekends. Here, we’ve imported
data for ten cities: Amsterdam, Athens, Barcelona, Berlin, Budapest,
Lisbon, London, Paris, Rome, and Vienna. For each city, we load two
separate files: one for weekdays and one for weekends.

``` r
amsterdam_weekdays <- read_csv(file.path(data_dir, "amsterdam_weekdays.csv"))
amsterdam_weekends <- read_csv(file.path(data_dir, "amsterdam_weekends.csv"))
athens_weekdays <- read_csv(file.path(data_dir, "athens_weekdays.csv"))
athens_weekends <- read_csv(file.path(data_dir, "athens_weekends.csv"))
barcelona_weekdays <- read_csv(file.path(data_dir, "barcelona_weekdays.csv"))
barcelona_weekends <- read_csv(file.path(data_dir, "barcelona_weekends.csv"))
berlin_weekdays <- read_csv(file.path(data_dir, "berlin_weekdays.csv"))
berlin_weekends <- read_csv(file.path(data_dir, "berlin_weekends.csv"))
budapest_weekdays <- read_csv(file.path(data_dir, "budapest_weekdays.csv"))
budapest_weekends <- read_csv(file.path(data_dir, "budapest_weekends.csv"))
lisbon_weekdays <- read_csv(file.path(data_dir, "lisbon_weekdays.csv"))
lisbon_weekends <- read_csv(file.path(data_dir, "lisbon_weekends.csv"))
london_weekdays <- read_csv(file.path(data_dir, "london_weekdays.csv"))
london_weekends <- read_csv(file.path(data_dir, "london_weekends.csv"))
paris_weekdays <- read_csv(file.path(data_dir, "paris_weekdays.csv"))
paris_weekends <- read_csv(file.path(data_dir, "paris_weekends.csv"))
rome_weekdays <- read_csv(file.path(data_dir, "rome_weekdays.csv"))
rome_weekends <- read_csv(file.path(data_dir, "rome_weekends.csv"))
vienna_weekdays <- read_csv(file.path(data_dir, "vienna_weekdays.csv"))
vienna_weekends <- read_csv(file.path(data_dir, "vienna_weekends.csv"))
```

## Data cleaning

### Data Tidying and Cleaning

First, we will modify each city’s dataset by adding a new column
day_type indicating whether the data is from a weekday or weekend. We
then join the ‘weekdays’ and ‘weekend’ datasets of individual datasets
into one dataset for a particular city, using full_join function. We
also add a new column city to each joined dataset, since we will be
combining all these cities datasets and thus would need to differentiate
the data of cities in some way for analysis and insights. This approach
maintains clarity and allows for detailed comparative analyses across
days and cities.

``` r
amsterdam <- full_join(amsterdam_weekdays %>% mutate(day_type = "Weekday"),
                       amsterdam_weekends %>% mutate(day_type = "Weekend")) %>% mutate(city = "Amsterdam")
athens <- full_join(athens_weekdays %>% mutate(day_type = "Weekday"),
                    athens_weekends %>% mutate(day_type = "Weekend")) %>% mutate(city = "Athens")
barcelona <- full_join(barcelona_weekdays %>% mutate(day_type = "Weekday"),
                       barcelona_weekends %>% mutate(day_type = "Weekend")) %>% mutate(city = "Barcelona")
berlin <- full_join(berlin_weekdays %>% mutate(day_type = "Weekday"),
                    berlin_weekends %>% mutate(day_type = "Weekend")) %>% mutate(city = "Berlin")
budapest <- full_join(budapest_weekdays %>% mutate(day_type = "Weekday"),
                      budapest_weekends %>% mutate(day_type = "Weekend")) %>% mutate(city = "Budapest")
lisbon <- full_join(lisbon_weekdays %>% mutate(day_type = "Weekday"), 
                    lisbon_weekends %>% mutate(day_type = "Weekend")) %>% mutate(city = "Lisbon")
london <- full_join(london_weekdays %>% mutate(day_type = "Weekday"),
                    london_weekends %>% mutate(day_type = "Weekend")) %>% mutate(city = "London")
paris <- full_join(paris_weekdays %>% mutate(day_type = "Weekday"),
                   paris_weekends %>% mutate(day_type = "Weekend")) %>% mutate(city = "Paris")
rome <- full_join(rome_weekdays %>% mutate(day_type = "Weekday"),
                  rome_weekends %>% mutate(day_type = "Weekend")) %>% mutate(city = "Rome")
vienna <- full_join(vienna_weekdays %>% mutate(day_type = "Weekday"),
                    vienna_weekends %>% mutate(day_type = "Weekend")) %>% mutate(city = "Vienna")
```

The next step involves combining these city-specific datasets into a
single dataset. Since our prior checks confirmed that all individual
city datasets share the same columns, we utilize bind_rows function to
combine them into a single comprehensive dataset for easier analysis
across multiple dimensions.

``` r
airbnb <- bind_rows(amsterdam, athens, barcelona, berlin, budapest, lisbon, london, paris, rome, vienna) %>% select(-c(...1, room_shared, room_private)) %>% select(city, day_type, everything())
airbnb
```

    ## # A tibble: 51,707 × 19
    ##    city      day_type realSum room_type  person_capacity host_is_superhost multi
    ##    <chr>     <chr>      <dbl> <chr>                <dbl> <lgl>             <dbl>
    ##  1 Amsterdam Weekday     194. Private r…               2 FALSE                 1
    ##  2 Amsterdam Weekday     344. Private r…               4 FALSE                 0
    ##  3 Amsterdam Weekday     264. Private r…               2 FALSE                 0
    ##  4 Amsterdam Weekday     434. Private r…               4 FALSE                 0
    ##  5 Amsterdam Weekday     486. Private r…               2 TRUE                  0
    ##  6 Amsterdam Weekday     553. Private r…               3 FALSE                 0
    ##  7 Amsterdam Weekday     215. Private r…               2 FALSE                 0
    ##  8 Amsterdam Weekday    2771. Entire ho…               4 TRUE                  0
    ##  9 Amsterdam Weekday    1002. Entire ho…               4 FALSE                 0
    ## 10 Amsterdam Weekday     277. Private r…               2 FALSE                 1
    ## # ℹ 51,697 more rows
    ## # ℹ 12 more variables: biz <dbl>, cleanliness_rating <dbl>,
    ## #   guest_satisfaction_overall <dbl>, bedrooms <dbl>, dist <dbl>,
    ## #   metro_dist <dbl>, attr_index <dbl>, attr_index_norm <dbl>,
    ## #   rest_index <dbl>, rest_index_norm <dbl>, lng <dbl>, lat <dbl>

This final combined dataset named airbnb now serves as the basis for all
subsequent analyses. It contains unified data from all selected European
cities, enabling us to perform comparative and statistical analyses more
effectively.

### Missing Datas

We will check for missing values across the entire consolidated airbnb
dataset. This was accomplished using the **is.na** function combined
with the **any** function, which helps in identifying any missing values
across all columns and rows.

``` r
any(is.na(airbnb))
```

    ## [1] FALSE

The result of this operation confirmed that there are no missing (NA)
values within the dataset. This finding indicates that our dataset is
well-prepared and does not require further steps commonly associated
with handling missing data. To prepare for the next phase of our
analysis, we can aim to explore and model the data without concerns
regarding data completeness or the need to address missing information.

## Analysis

### Adjusting Outliers in listing prices

Outliers are extreme values that fall significantly outside the typical
range of data. In the context of Airbnb prices, these are unusually high
or low prices that do not represent typical listings.

To better understand the distribution of listing prices and the extent
of outliers, a density plot is drawed:

``` r
ggplot(data = airbnb) + geom_density(aes(x = realSum)) +
  labs(title = "Density Plot of Listing Prices",
       x = "Listing Price (€)",
       y = "Density")
```

![](/Users/hillll/Projects/airbnb-price-modeling/docs/Airbnb_Pricing_Project_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

The lower-priced listings are concentrated near the origin with a sharp
peak. The plot also displays a long tail extending toward higher prices.
This long tail indicates the presence of outliers — listings that are
priced significantly higher than the typical market rate. These could be
luxury accommodations or properties in extremely high-demand locations.

To accurately identify outliers in listing prices, i.e. the realSum
column, we utilize the interquartile range (IQR) method:

``` r
iqr <- IQR(airbnb$realSum)
lower_bound <- quantile(airbnb$realSum, 0.25) - 1.5 * iqr
upper_bound <- quantile(airbnb$realSum, 0.75) + 1.5 * iqr
outliers <- airbnb$realSum < lower_bound | airbnb$realSum > upper_bound
percentage_outliers <- sum(outliers) / nrow(airbnb) * 100

percentage_outliers
```

    ## [1] 7.082213

Using IQR() function and quantile() function, we identified outliers
that are greater than upper_bound and less than lower_bound. We create a
logical vector where each element is TRUE if the corresponding price in
airbnb\$realSum is an outliers. To understand the extent of the outlier
issue, we calculate the percentage of listing prices that are considered
outliers. This is done by summing the TRUE values in the outliers vector
and dividing by the total number of listings in the dataset. The
percentage of outliers is 7.08% of the total pricing data.

The skewness caused by high-price outliers may complicate average price
calculations and statistical modeling. Therefore, we applied a
logarithmic transformation of the price data. This transformation
compresses the range of higher prices more effectively than lower ones,
thus minimizing the influence of extreme values and enhancing the
clarity of visualization. It also renders the distribution more suitable
for statistical methods that require a normal distribution.

``` r
airbnb_norm <- airbnb %>% mutate(realSum = log10(realSum))
```

This final combined dataset named airbnb_norm now serves as the basis
for all subsequent analyses.

### Analysis 1: How is the listing price distributed across major European cities? How does it vary between weekdays and weekends?

To comprehensively explore the distribution of listings across cities
and differentiate between weekdays and weekends, a bar chart was
employed:

``` r
ggplot(data = airbnb_norm) + geom_bar(aes(fill = day_type, x = city), position = "dodge") + 
  labs(
    title = "Distribution of Listings by City and Day Type",
    x = "City",
    y = "Count of Listings",
    fill = "Day Type")
```

![](/Users/hillll/Projects/airbnb-price-modeling/docs/Airbnb_Pricing_Project_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

Notably, cities like London and Paris have a high volume of listings
regardless of the day, indicating their popularity as tourist
destinations. Conversely, cities like Amsterdam and Athens show fewer
listings, which could reflect tighter local regulations or fewer demand.

Boxplots were used to visually represent the price distribution across
cities and by day type. We use boxplots because it foucs on the median
and quartiles listing prices, which are less sentitive to outliers than
means. It helps in observing the spread and central values of prices
without the skewing effect of extreme outliers.

``` r
ggplot(data = airbnb_norm) + geom_boxplot(aes(x = city, y = realSum, fill = day_type))  +
  labs(x = "City", 
       y = "Total Price (€)", 
       title = "Comparison of Daily Listing Prices by City and Day Type",
       fill = "Day Type")
```

![](/Users/hillll/Projects/airbnb-price-modeling/docs/Airbnb_Pricing_Project_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

There is no significant difference in median listing prices between
weekdays and weekends, which contradicts the common expectation of
weekend premium. This anomaly suggests that other factors such as
location desirability, local events, or seasonal demand might play more
significant roles in pricing than merely the day of the week. The
near-uniform pricing between weekdays and weekends across all cities
highlights a unique aspect of the European Airbnb market, potentially
driven by consistent tourist demand or effective price regulation
strategies by hosts to maintain competitive yet stable pricing.

The analysis of price distribution across cities and day type also
provides insights on tourism strategies. Cities like Rome, Budapest, and
Athens are identified as more economical options for tourists, offering
lower prices while holds similar popularity as London.

### Analysis 2: How do room types influence Airbnb pricing across major European cities?

We start by evaluating the distribution of room types — entire
homes/apartments, private rooms, and shared rooms — across cities. In
the following code, the original data is grouped by city and room type,
and the percentage of each room type is calculated within its respective
city.

This data is then plotted as a composition chart where each bar
represents a city and is filled according to the proportion of room
types. The **position = “fill”** ensures that each bar is normalized to
fill the y-axis, facilitating direct comparison across cities. The use
of **geom_text()** add text annotations to display exact percentages
within the bars.

``` r
airbnb_counts <- airbnb_norm %>%
  count(city, room_type) %>%
  group_by(city) %>%
  mutate(percentage = n / sum(n)) %>%
  ungroup()

ggplot(airbnb_counts, aes(x = city, y = percentage, fill = room_type)) +
  geom_bar(stat = "identity", position = "fill") +
  geom_text(aes(label = scales::percent(percentage, accuracy = 0.1)),
            position = position_fill(vjust = 0.9), # Adjust vertical position inside the bars
            color = "white", size = 2.5) +  # You can adjust color and size of text for better visibility
  labs(x = "City", y = "Percentage", fill = "Room Types",
       title = "Distribution of Airbnb Room Types Across European Cities") 
```

![](/Users/hillll/Projects/airbnb-price-modeling/docs/Airbnb_Pricing_Project_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

From the composition chart, we could obsevere significant differences in
the proportion of the room type accross cities. The vast majority (above
70%) of listings are entire homes in Athens, Budapest, Paris and Vienna.
This indicates a market preference for more spacious and private
accommodations which cater to tourists and families. This preference
aligns with these cities’ reputations as major tourist destinations
where visitors often seek comfort and privacy.

On the other hand, private rooms constitute more than 60% of listings in
Barcelona and Berlin. It likely reflects local regulatory influences
that restrict certain types of short-term rentals. For instance,
stringent regulations in Barcelona aim to protect local housing markets
by limiting private rentals.

Next, we explore how room types affect listing prices within these
cities. Again, boxplots are used in visualization to mitigate the effect
of outliers by focusing on median listing prices.

``` r
ggplot(data = airbnb_norm, aes(x = city, y = realSum, fill = room_type)) + 
  geom_boxplot(outlier.size = 0.5) + 
  labs(x = "City", 
       y = "Listing Price (€)", 
       title = "Comparison of Daily Listing Prices by City and Room Type",
       fill = "Room Type")
```

![](/Users/hillll/Projects/airbnb-price-modeling/docs/Airbnb_Pricing_Project_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

The boxplot presents a direct comparison of daily listing prices
segmented by room type across these cities. It shows that entire
homes/apartments generally result in higher prices compared to private
or shared rooms, with this trend being especially pronounced in cities
like Paris, London, and Amsterdam. The consistent higher pricing of
entire homes across all cities underscores their valued features such as
space and privacy, which are premium considerations for travelers.

### Analysis 3: How do different location factors affect Airbnb pricing across major European cities?

We focus on four location-specific factors: 1. dist: distance from city
center in kilometers; 2. metro_dist: distance from nearest metro station
in kilometers; 3. attr_index_norm: normalized attraction index of the
listing location from a scale 0-100; 4. rest_index_norm: normalized
restaurant index of the listing location, from a scale 0-100.

We employed linear models to assess the correlation between distance
from city centers and metro stations on listing prices. The models were
visualized using trend lines(geom_smooth) for each city, represented by
different colors. A subset of the data (sampled_data) is created by
randomly selecting 20 listings from each city to ensure that the plot
remains clear and not overly cluttered. This sampling is performed
within a grouped structure by city. On the plots, each point represents
a sampled listing, aligning with the corresponding city’s color and
grouped by city to ensure consistent trend analysis.

``` r
sampled_data <- airbnb_norm %>% group_by(city) %>% sample_n(size = 20)

dist_realSum <- ggplot(data = airbnb_norm, aes(x = dist, y = realSum, color = city)) +
  geom_smooth(method = "lm", se = FALSE, aes(group = city)) + 
  geom_point(data = sampled_data, aes(group = city), alpha = 0.5) + 
  labs(y = "Listing Price (€)", x = "Distance from City Center", title = "Price vs. Distance form Center by City")
dist_realSum
```

![](/Users/hillll/Projects/airbnb-price-modeling/docs/Airbnb_Pricing_Project_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

``` r
metrodist_realSum <- ggplot(data = airbnb_norm, aes(x = metro_dist, y = realSum, color = city)) +
  geom_smooth(method = "lm", se = FALSE, aes(group = city)) + 
  geom_point(data = sampled_data, aes(group = city), alpha = 0.5) + 
  labs(y = "Listing Price (€)", x = "Distance from Nearest Metro Station", title = "Price vs. Metro Sation Distance by City")
metrodist_realSum
```

![](/Users/hillll/Projects/airbnb-price-modeling/docs/Airbnb_Pricing_Project_files/figure-gfm/unnamed-chunk-13-2.png)<!-- -->

The trend lines clearly demonstrate that closer proximity to city
centers and metro stations significantly increases Airbnb listing
prices. However, the intensity of this relationship varies by city, with
metropolitan hubs like Paris and London showing a sharper price gradient
as one moves away from the center. This is indicative of the premium
travelers are willing to pay for convenience and accessibility to major
tourist destinations.

Further, we extended our exploration to the effects of the attractions
and restaurants indexes, using a similar modeling approach.

``` r
attr_realSum <- ggplot(data = airbnb_norm, aes(x = attr_index_norm, y = realSum, color = city)) +
  geom_smooth(method = "lm", se = FALSE, aes(group = city)) + 
  geom_point(data = sampled_data, aes(group = city), alpha = 0.5) + 
  labs(y = "Listing Price (€)", x = "Normalized Attraction Index", title = "Price vs. Attraction Index by City")
attr_realSum
```

![](/Users/hillll/Projects/airbnb-price-modeling/docs/Airbnb_Pricing_Project_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

``` r
rest_realSum <- ggplot(data = airbnb_norm, aes(x = rest_index_norm, y = realSum, color = city)) +
  geom_smooth(method = "lm", se = FALSE, aes(group = city)) + 
  geom_point(data = sampled_data, aes(group = city), alpha = 0.5) + 
  labs(y = "Listing Price (€)", x = "Normalized Restaurant Index", title = "Price vs. Restaurant Index by City")
rest_realSum
```

![](/Users/hillll/Projects/airbnb-price-modeling/docs/Airbnb_Pricing_Project_files/figure-gfm/unnamed-chunk-14-2.png)<!-- -->

Our findings indicate that listings placed in areas with a higher
concentration of attractions and restaurants also lead to higher prices.
The graphs demonstrate that while all cities generally reflect the trend
of location value influencing rental prices, the degree of this impact
varies considerably across different cities. Cities with globally
recognized attractions, such as Paris and Amsterdam, show a more
significant price increase compared to cities like Lisbon and Budapest,
where the correlation is less significant.

### Analysis 4: How does a combination of house features, location factors, and host quality predict listing price?

In previous questions, we explored individual characteristics on the
listing price. This question aims to examine how a combination of house
features, location factors, and host quality can predict Airbnb listing
prices and how effective the model is. From previous exploration, we
could see these factors may impact cities differently even though they
follow the same trends. In this case, London is selected as an example
for the modeling, as it provides the largest sample size of 9,460
listings.

### Model 1: Multivariable linear model for Airbnb listing prices (realSum)

**Methodology**

The analysis utilized a dataset airbnb filtered to include only listings
located in the city of London. The linear regression model was employed
to predict the listing prices (realSum) based on various explanatory
variables including room type, person capacity, number of bedrooms,
distance from city center (dist), distance from the nearest metro
station (metro_dist), normalized attraction index (attr_index_norm),
normalized restaurant index (rest_index_norm), overall guest
satisfaction, cleanliness rating, and whether the host is a superhost
(host_is_superhost).

``` r
london_price <- airbnb %>% filter(city == "London")

mod_london <- lm(realSum ~ room_type + person_capacity + bedrooms + 
                           dist + metro_dist + attr_index_norm + rest_index_norm +
                           guest_satisfaction_overall + cleanliness_rating + host_is_superhost, 
                 data = london_price)
summary(mod_london)
```

    ## 
    ## Call:
    ## lm(formula = realSum ~ room_type + person_capacity + bedrooms + 
    ##     dist + metro_dist + attr_index_norm + rest_index_norm + guest_satisfaction_overall + 
    ##     cleanliness_rating + host_is_superhost, data = london_price)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ##  -993.6   -97.8   -28.5    41.0 14177.4 
    ## 
    ## Coefficients:
    ##                              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                -165.85478   46.97437  -3.531 0.000416 ***
    ## room_typePrivate room      -201.91650   10.28852 -19.625  < 2e-16 ***
    ## room_typeShared room       -242.62259   59.08165  -4.107 4.05e-05 ***
    ## person_capacity              33.85611    4.86443   6.960 3.62e-12 ***
    ## bedrooms                    173.31231    8.96684  19.328  < 2e-16 ***
    ## dist                          9.18234    3.31992   2.766 0.005688 ** 
    ## metro_dist                  -21.48787    4.74851  -4.525 6.10e-06 ***
    ## attr_index_norm               9.32645    0.92143  10.122  < 2e-16 ***
    ## rest_index_norm               0.01779    1.40132   0.013 0.989870    
    ## guest_satisfaction_overall    1.21899    0.55558   2.194 0.028251 *  
    ## cleanliness_rating            1.85978    5.44959   0.341 0.732908    
    ## host_is_superhostTRUE        20.74060   11.76652   1.763 0.077985 .  
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 413.7 on 9981 degrees of freedom
    ## Multiple R-squared:  0.2306, Adjusted R-squared:  0.2298 
    ## F-statistic:   272 on 11 and 9981 DF,  p-value: < 2.2e-16

**Analysis of the summary data and insights**  
The summary data of this model shows that it explains approximately 23%
of the variance in listing prices (Adjusted R-squared = 0.2298). While
this is significant, it suggests that many other unaccounted factors
could also impact pricing.

The coefficients of variables indicate the significance of different
predictors in influencing listing prices. Significant predictors include
room types, number of bedrooms, person capacity and proximity to metro
stations. Meanwhile, predictors such as the restaurant index, guest
satisfaction rating, and cleanliness rating were not significant.

The outcome of this model revealed an interesting aspect regarding the
impact of locational factors on listing prices. Upon all four locational
factors, the overall convenience offered by a location is a crucial
determinant of listing prices, while attraction and restaurant indexes
paly little effect.

**Predictive accuracy**

To assess the model’s predictive performance, we first add predictions
and residuals to the original data set, using the model london_mod we
created along with add_predictions and add_residuals function.

The predicted prices were plotted against actual prices:

``` r
london_price_pred_resid <- london_price %>% add_predictions(mod_london) %>% add_residuals(mod_london)

ggplot(data = london_price_pred_resid, aes(x = pred, y = realSum)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(x = "Predicted Prices (€)", y = "Actual Prices", title = "Plot of Actual vs. Predicted Prices")
```

![](/Users/hillll/Projects/airbnb-price-modeling/docs/Airbnb_Pricing_Project_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

The plot of actual versus predicted prices demonstrates that the linear
model predicts lower-priced listings relatively well, as the actual data
points are clustered around the predicted line at lower price levels.
However, as the price increases, the data points begin to spread from
the line, suggesting that the model’s accuracy decreases for luxury
listings. The presence of several high-priced listings that are far from
the predicted values indicates that the model does not fully capture the
factors that lead to higher prices.

The residuals were plotted against Predicted prices:

``` r
ggplot(london_price_pred_resid, aes(x = pred, y = resid)) +
  geom_point(alpha = 0.2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(x = "Predicted Prices (€)", y = "Residuals", title = "Residual Plot for London Airbnb Listings") 
```

![](/Users/hillll/Projects/airbnb-price-modeling/docs/Airbnb_Pricing_Project_files/figure-gfm/unnamed-chunk-17-1.png)<!-- -->

The majority of residuals are ditributed around the zero line,
suggesting that the model’s predictions are unbiased on average.
However, there is a slightly downward trend of residuals, suggesting
this model may overestimates prices for lower-cost listings.
Additionally, there are several outliers where the model significantly
underestimates or overestimates prices. These outliers likely represent
unique properties that are not adequately captured by the model’s
current variables.

### Model 2: Log-transformed model for London Airbnb listing prices (realSum)

**Methodology**

Considering the presence of exceptionally high listing prices in the
original data, we would like to explore the log-transformed model to see
if this transformation could improve the model fit. We used the
airbnb_norm dataset, where a log transformation has been applied to the
realSum column, representing the listing prices.

``` r
log_london_price <- airbnb_norm %>% filter(city == "London")

mod_log <- lm(realSum ~ room_type + person_capacity + bedrooms + 
                           dist + metro_dist + attr_index_norm + rest_index_norm +
                           guest_satisfaction_overall + cleanliness_rating + host_is_superhost, 
                 data = log_london_price)
summary(mod_log)
```

    ## 
    ## Call:
    ## lm(formula = realSum ~ room_type + person_capacity + bedrooms + 
    ##     dist + metro_dist + attr_index_norm + rest_index_norm + guest_satisfaction_overall + 
    ##     cleanliness_rating + host_is_superhost, data = log_london_price)
    ## 
    ## Residuals:
    ##      Min       1Q   Median       3Q      Max 
    ## -0.50637 -0.10363 -0.01969  0.07729  1.88386 
    ## 
    ## Coefficients:
    ##                              Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                 2.1678755  0.0181893 119.184  < 2e-16 ***
    ## room_typePrivate room      -0.2797985  0.0039839 -70.232  < 2e-16 ***
    ## room_typeShared room       -0.3379881  0.0228774 -14.774  < 2e-16 ***
    ## person_capacity             0.0434549  0.0018836  23.070  < 2e-16 ***
    ## bedrooms                    0.0851468  0.0034721  24.523  < 2e-16 ***
    ## dist                       -0.0051209  0.0012855  -3.983 6.84e-05 ***
    ## metro_dist                 -0.0237809  0.0018387 -12.934  < 2e-16 ***
    ## attr_index_norm             0.0040039  0.0003568  11.222  < 2e-16 ***
    ## rest_index_norm             0.0022720  0.0005426   4.187 2.85e-05 ***
    ## guest_satisfaction_overall  0.0003245  0.0002151   1.509    0.131    
    ## cleanliness_rating          0.0141215  0.0021102   6.692 2.32e-11 ***
    ## host_is_superhostTRUE       0.0197654  0.0045562   4.338 1.45e-05 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 0.1602 on 9981 degrees of freedom
    ## Multiple R-squared:  0.6757, Adjusted R-squared:  0.6754 
    ## F-statistic:  1891 on 11 and 9981 DF,  p-value: < 2.2e-16

**Analysis of Predictive Accuracy**

The adjusted R-squared of 0.6754. It suggest that approximately 67.54%
of the variability in Airbnb listing prices in London is explained by
the model. Comparing this to the previous model using non-transformed
data with a R-squared of 0.2298, the log-transformed model shows
improved fit statistics.

``` r
log_london_price_pred_resid <- log_london_price %>% add_predictions(mod_log) %>% add_residuals(mod_log)

ggplot(data = log_london_price_pred_resid, aes(x = pred, y = realSum)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  labs(x = "Predicted Prices in Log Scale", y = "Actual Prices in Log Scale", title = "Plot of Actual vs. Predicted Prices in Log Scale")
```

![](/Users/hillll/Projects/airbnb-price-modeling/docs/Airbnb_Pricing_Project_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

The plot of actual versus predicted prices on a log scale demonstrates a
strong linear relationship, with most data points closely aligned with
the red trend line. This indicates effective price prediction for most
listings using the log-transformed model.

``` r
ggplot(log_london_price_pred_resid, aes(x = pred, y = resid)) +
  geom_point(alpha = 0.2) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  labs(x = "Predicted Prices in Log Scale", y = "Residuals", title = "Residual Plot for London Airbnb Listings") 
```

![](/Users/hillll/Projects/airbnb-price-modeling/docs/Airbnb_Pricing_Project_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

Residuals are centered around zero without a discernible pattern, which
supports the validity of the regression results. However, some outliers
at both ends implies limitations in capturing extreme values with the
current predictors.

## Conclusions and next steps

This project conducted an in-depth analysis of the factors influencing
Airbnb listing prices across major European cities, drawing from a
dataset that included a variety of property, location, and host-related
attributes. The analysis highlighted clear correlations between Airbnb
prices and key variables such as room type and proximity to city centers
and metro stations. In conclusion, the log-transformed linear regression
model is a better prediction over the linear model without
transformation. It is effective in dealing with the skewed distributions
with the presence of outliers that are often found in pricing data.

Despite the valuable insights, the study has several limitations. The
analysis was confined to data from European cities, leaving it uncertain
whether the observed patterns would be applicable in other global
regions under different economic conditions and regulatory frameworks.
Additionally, the dataset lacked detailed temporal information that
could influence pricing, such as seasonal fluctuations or special
events, potentially introducing variability to our price predictions.
There are also limitations in the modeling approach. Currently, each
variable is weighted equally, whereas in reality, some variables may
have a more significant impact at different price ranges.

For future research, expanding the dataset to include information from
other continents could validate whether the observed relationships are
consistent globally. When creating the model, different weights could be
put onto the variables to enhance the accuracy of the predictions.
Exploring a correlation matrix between these predictors and listing
prices could assist in assigning differentiated weights to each
variable, better reflecting the real-world scenario of pricing.
