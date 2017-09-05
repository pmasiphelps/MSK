# update content

import numpy as np
import pandas as pd

from pubmed.models import Abstract, Article

#abstracts = pd.read_csv(input)
#abstract.pmid = 

abstract1  = Abstract.objects.get(pk=1)
print(abstract1.title)



