import numpy as np
from skopt import BayesSearchCV
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier

iris = load_iris()
X = iris.data
y = iris.target

param_space = {
    'n_estimators': (10,100),
    'max_depth': (1,10),
    'min_samples_split': (2,10),
    'min_samples_leaf': (1,10),
    'max_features': (1,4),

}


opt = BayesSearchCV(
    RandomForestClassifier(),
    param_space,
    n_iter=20,
    cv=5,
    n_jobs=-1,
)

opt.fit(X,y)

