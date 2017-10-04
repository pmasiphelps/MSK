# MSK
NYC Data SA Capstone
PPT link: https://docs.google.com/presentation/d/1pcZGAhYuSqnVWtpQaehIzNMs2ElhkWBSCBmtz0l52uU/edit?usp=sharing

# Genetic Mutation Cancer Classification Project - Natural Language Processing and Machine Learning
## Contributors: Katie Critelli, Patrick Masi-Phelps, Sam Trost, and Jing Wang
## Blog post: https://blog.nycdatascience.com/student-works/redefining-cancer-treatment-predicting-gene-mutations-advance-personalized-medicine/

Welcome to the repository for the Cancer Genetic Analysis Team (CGAT) of NYC Data Science Academy! 

We put together a package of solutions to help cancer researchers speed up the process of classifying genetic mutation variations as drivers or passengers of cancer tumor growth. Memorial Sloan Kettering Cancer Center put out a public competition soliciting machine learning models to take relevant medical research text and classify the associated genetic mutations into one of nine mutually exclusive classes, each contributing differently to cancer tumor growth (or not). Link to associated Kaggle competition: https://www.kaggle.com/c/msk-redefining-cancer-treatment

Our solutions include:
  - RShiny app with interactive visualizations, including distributions of genes, variations, and mutation characteristics broken down by class, as well as text features obtained from medical research papers used to manually classify mutations.
  - Machine learning classification models using vectorized text features to classify genetic mutations into one of nine classes
  - Selenium web scraping app to scrape PubMed for new research papers related to genetic mutations and associated cancer risks
  - Django app and database of research text which allows a user to enter new medical text and (almost) immediately see the class (from 1-9) of the associated genetic mutation - as it relates to cancer risk.

You can find a deck summarizing our project pipeline, including data analysis and visualizations (and RShiny app), machine learning models, findings, Django app, and areas for further improvement in the file "MSK Kaggle Project (1).pdf".

iPython notebooks and R files used in data preprocessing, visualization, and modeling can be found in the appropriate folder. 
