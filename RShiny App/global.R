library('ggplot2') # visualization
library('ggthemes') # visualization
library('scales') # visualization
library('grid') # visualisation
library('gridExtra') # visualisation
library('corrplot') # visualisation
library('ggfortify') # visualisation
library('ggraph') # visualisation
library('igraph') # visualisation
library('dplyr') # data manipulation
library('readr') # data input
library('tibble') # data wrangling
library('tidyr') # data wrangling
library('stringr') # string manipulation
library('forcats') # factor manipulation
library('tidytext') # text mining
library(DT)

library(plotly)
cancer = read.csv('train_aa_extra.csv')
#top12 mutations
types_mutations = mutate(cancer, Variation = ifelse(toupper(Variation) != Variation, as.character(Variation), "Point Mutation"))
types_mutations = mutate(types_mutations, Variation = ifelse(grepl("_", Variation), "Insertion/Deletion", Variation))
types_mutations = mutate(types_mutations, Variation = ifelse(grepl("Fusion", Variation), "Fusion", Variation))
types_mutations = mutate(types_mutations, Variation = ifelse(grepl("Exon", Variation), "Exon del/ins/mut", Variation))
types_mutations = mutate(types_mutations, Variation = ifelse(grepl("Exon", Variation), "Exon del/ins/mut", Variation))
types_mutations = mutate(types_mutations, Variation = ifelse(grepl("DNA binding domain", Variation), "DNA binding domain del/ins/mut", Variation))
types_mutations = mutate(types_mutations, Variation = ifelse(grepl("EGFR", Variation), "EGFR Domain Mutant", Variation))
types_mutations = types_mutations %>% group_by(.,Variation) %>% summarise(.,Counts = n()) %>% arrange(.,desc(Counts)) %>% head(12)
top12_mutations = types_mutations
print('test')

top12_mutations$Variation = as.factor(top12_mutations$Variation)
#My Data
train_extra = read.csv('train_aa_extra.csv')

#General Data

test_var = read.csv('test_variants.csv')

train <- read_csv('training_variants.csv')
test  <- read_csv('test_variants.csv')

train_txt_dump <- tibble(text = read_lines('training_text', skip = 1))
train_txt <- train_txt_dump %>%
  separate(text, into = c("ID", "txt"), sep = "\\|\\|")
train_txt <- train_txt %>%
  mutate(ID = as.integer(ID))

test_txt_dump <- tibble(text = read_lines('test_text', skip = 1))
test_txt <- test_txt_dump %>%
  separate(text, into = c("ID", "txt"), sep = "\\|\\|")
test_txt <- test_txt %>%
  mutate(ID = as.integer(ID))

foo <- train %>%
  select(ID, Class)
t1 <- train_txt %>% select(ID, txt) %>% unnest_tokens(word, txt)
t1_class <- full_join(t1, foo, by = "ID")



#Barplot-related Data
barplot_data = cancer %>% group_by(.,Class) %>% summarise(.,Counts = n())
# Basic barplot

barplot_data$Class = as.factor(barplot_data$Class)

#Histogram-related Data
hydro = cancer$hydro_diff
elec = cancer$elec_diff

#Data for bargraph of Mutation Types
#No necessary data here

###Data for Most frequent words by class
frequency <-t1_class %>%
  count(Class, word)

tf_idf <- frequency %>%
  bind_tf_idf(word, Class, n)

#Top Genes in the Test and Training Data
top_gene <- cancer %>%
  group_by(Gene) %>%
  summarise(ct = n()) %>%
  filter(ct > 40)

top_test_gene <- test_var %>%
  group_by(Gene) %>%
  summarise(ct = n()) %>%
  filter(ct > 40)
###Most frequent words by class
frequency <-t1_class %>%
  count(Class, word)




