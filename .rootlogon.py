from random import randint
import ROOT

ROOT.RooRandom.randomGenerator().SetSeed(randint(0, 10000))
ROOT.gROOT.SetBatch(False)
ROOT.gROOT.Macro('~/.rootlogon.C')
