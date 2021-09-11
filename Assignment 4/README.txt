----------
# Exercise 3
----------

## Description: 
### CEPSTRUM via HOMOMORPHIC FILTERING:
- Acquire voice samples making the five vowel sounds
- Compute the cepstrum with different methods
- Lifter the cepstrum domain signals
- Try to synthesize back the voiced signals

## Files:
- Main_4.m				: Our main file for generation of plots and 
					  (reconstructed) sound samples.

- VowelAnalysis.m			: Estimates the impulse response of the
					  speech production of the vowel using homomorphic
					  filtering (liftering) in the cepstrum domain.

- vowelPlots.m 				: Plots of segments of the original signals
					  to have a clearer view of the vowels for
					  each subject's pitch and vowel forms.

- getSamples.m				: Setup function to import files from folder

- getOriginalPitch.m			: Returns the total excitation signal of the
					  original speech sample to convolute with the
					  estimated impulse response.

- CepWin.m 				: Cepstrograms of real and complex cepstrum

_ CCepstrogram.m, cepstrogram.m, 
  splot.m, stackedplot.m		: Helper functions for CepWin.m

- KavelidisFrantzis_9351_ex4.pdf is the report for the assignment

- Samples 				: The folder with the sound samples

Kavelidis Frantzis Dimitrios 						30.5.2021