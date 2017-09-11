cancer = read.csv('./Downloads/nlp_with_deep_learning/train_aa_extra.csv')
test_var = read.csv('./Downloads/test_variants.csv')
View(cancer)
library(ggplot2)
library(dplyr)
library(stringr)

cancer %>% filter(.,Class == '9')

barplot_data = cancer %>% group_by(.,Class) %>% summarise(.,Counts = n())
# Basic barplot
View(barplot)
barplot_data$Class = as.factor(barplot_data$Class)
num_class_bargraph = ggplot(data=barplot_data, aes(x=Class, y=Counts)) +
  geom_bar(stat="identity", width=0.5, color = "purple", fill="steelblue") + 
  geom_text(aes(label=Counts), vjust=-0.3, size=3.5) + theme_minimal() + 
  labs(x="Classes",y="Number of Entries by Class") + ggtitle('Number of Data Entries for Each Class')+
  theme(plot.title = element_text(hjust = .5))
##Classes 3, 8, and 9 are the smallest. Overall, in the training set, 
##Classes are highly unbalanced

#Histogram
hydro = cancer$hydro_diff
elec = cancer$elec_diff
hist(hydro, xlab="Absolute value of electric/hydrophobic difference", main= "Distribution of Mutations across Electric/Hydrophobic Spectrum", 
     breaks = 12, xlim=c(0,10),col='skyblue',border=F)
hist(elec, breaks = 12, add=T,col=scales::alpha('red',.5),border=F)

#Bar graph of top mutation types (12)
library(plotly)
types_mutations = mutate(cancer, Variation = ifelse(toupper(Variation) != Variation, as.character(Variation), "Point Mutation"))
types_mutations = mutate(types_mutations, Variation = ifelse(grepl("_", Variation), "Insertion/Deletion", Variation))
types_mutations = mutate(types_mutations, Variation = ifelse(grepl("Fusion", Variation), "Fusion", Variation))
types_mutations = mutate(types_mutations, Variation = ifelse(grepl("Exon", Variation), "Exon del/ins/mut", Variation))
types_mutations = mutate(types_mutations, Variation = ifelse(grepl("Exon", Variation), "Exon del/ins/mut", Variation))
types_mutations = mutate(types_mutations, Variation = ifelse(grepl("DNA binding domain", Variation), "DNA binding domain del/ins/mut", Variation))
types_mutations = mutate(types_mutations, Variation = ifelse(grepl("EGFR", Variation), "EGFR Domain Mutant", Variation))
types_mutations = types_mutations %>% group_by(.,Variation) %>% summarise(.,Counts = n()) %>% arrange(.,desc(Counts)) %>% head(12)
top12_mutations = types_mutations
View(top12_mutations)
top12_mutations$Variation = as.factor(top12_mutations)
mutation_types_bargraph = ggplot(data=top12_mutations, aes(x=reorder(Variation, -Counts), y=Counts)) +
  geom_bar(stat="identity", width=0.5, color = "purple", fill="steelblue") + 
  geom_text(aes(label=Counts), vjust=-0.3, size=3.5) + theme_minimal() + 
  labs(x="Mutation Type",y="Number of Occurrences") + ggtitle('Top 12 Mutation Types by Frequency')+
  theme(plot.title = element_text(hjust = .5)) + theme(axis.text.x = element_text(angle = 25, hjust = 1))
mutation_types_bargraph

#Next section is visualizing the Gene-specific Data
top_gene <- cancer %>%
  group_by(Gene) %>%
  summarise(ct = n()) %>%
  filter(ct > 40)

top_gene %>%
  ggplot(aes(reorder(Gene, ct, FUN = min), ct)) +
  geom_point(size = 3, color = 'steelblue') +
  labs(x = "Gene", y = "Frequency") +
  coord_flip() + ggtitle('Most Common Genes in Training Data') + 
  theme(plot.title = element_text(hjust = .5))

top_test_gene <- test_var %>%
  group_by(Gene) %>%
  summarise(ct = n()) %>%
  filter(ct > 40)

top_test_gene %>%
  ggplot(aes(reorder(Gene, ct, FUN = min), ct)) +
  geom_point(size = 3, color = 'steelblue') +
  labs(x = "Gene", y = "Frequency") +
  coord_flip() + ggtitle('Most Common Genes in Test Data') + 
  theme(plot.title = element_text(hjust = .5))

###Top Genes by Class
cancer %>%
  filter(Gene %in% cancer$Gene) %>%
  ggplot(aes(Gene)) +
  geom_bar(color = 'darkblue', fill = 'skyblue') +
  theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=7)) +
  facet_wrap(~ Class) + ggtitle('Genes Represented in Each Class') + 
  theme(plot.title = element_text(hjust = .5))

cancer %>%
  filter(Gene %in% str_c(top_gene$Gene)) %>%
  ggplot(aes(Gene)) +
  geom_bar(color = 'darkblue', fill = 'skyblue') +
  theme(axis.text.x  = element_text(angle=90, vjust=0.5, size=7)) +
  facet_wrap(~ Class) + ggtitle('Genes Represented in Each Class') + 
  theme(plot.title = element_text(hjust = .5))

#Length of Text entries for the train vs. the test sets
#Word frequency comparisons across classes
frequency <-t1_class %>% #t1_class should be subset
  count(Class, word) %>%
  filter(n > 2e1) %>%
  group_by(Class) %>%
  mutate(freq = n / sum(n)) %>% 
  select(-n) %>% 
  spread(Class, freq) %>% 
  gather(Class, freq, `3`,`5`)

ggplot(frequency, aes(x = freq, y = `9`, color = abs(`9` - freq))) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.1, height = 0.1) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  #scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray95") +
  facet_wrap(~Class, ncol = 2) +
  theme(legend.position="none") +
  labs(y = "Class 9", x = NULL)
