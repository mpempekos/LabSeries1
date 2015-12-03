module softMetrics

import volumeAndDuplication;
import unitSizeAndComplexity;
import IO;

void runMetrics() {
		
	//project = |project://softEvolTest|;	
	project = |project://smallsql0.21_src|;
	
	aux1 = checkVolumeAndDuplication(project);
	aux2 = checkUnitSizeAndCyclomaticComplexity(project);
	
	str volumeScore = aux1[0];
	str duplicationScore = aux1[1];
	str unitSizeScore = aux2[0];
	str complexityScore = aux2[1];
	
	int volumeScoreNumber = scoreStrToInt(volumeScore);
	int duplicationScoreNumber = scoreStrToInt(duplicationScore);
	int unitSizeScoreNumber = scoreStrToInt(unitSizeScore);
	int comlexityScoreNumber = scoreStrToInt(complexityScore);
	
	real analysability = (volumeScoreNumber + duplicationScoreNumber + unitSizeScoreNumber /*+ unitTestingScoreNumber*/) / 3.0; //4.0
	real changeability = (comlexityScoreNumber + duplicationScoreNumber) / 2.0;
	//real stability = unitTestingScoreNumber;
	real testability = (comlexityScoreNumber + unitSizeScoreNumber /*+ unitTestingScoreNumber*/) / 2.0; //3.0 	
	
	println("analysability: <scoreIntToStr(analysability)>");
	println("changeability: <scoreIntToStr(changeability)>");
	//println("stability: <scoreIntToStr(stability)>");
	println("testability: <scoreIntToStr(testability)>");
	
	real maintainability = (analysability + changeability + testability /*+ stability*/) / 3.0; //4.0
	
	println("*******************");
	println("maintainability: <scoreIntToStr(maintainability)>");
	println("*******************");
}

int scoreStrToInt(str score) {
	switch(score){
		case "++": return 5;
		case "+": return 4;
		case "o": return 3;
		case "-": return 2;
		case "--": return 1;
	}
}

str scoreIntToStr(real score) {
	if(score <= 1) return "--";
	else if(score <= 2) return "-";
	else if(score <= 3) return "o";
	else if(score <= 4) return "+";
	else return "++";	
}