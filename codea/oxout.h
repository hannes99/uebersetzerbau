

struct yyyT1 {char *name; int line;}; 
typedef struct yyyT1 *yyyP1; 


struct yyyT2 {long long value;}; 
typedef struct yyyT2 *yyyP2; 


struct yyyT3 {nnode names, labels; char *name_up; int line; struct Tree *tree; }; 
typedef struct yyyT3 *yyyP3; 


struct yyyT4 {nnode names, labels; }; 
typedef struct yyyT4 *yyyP4; 


struct yyyT5 {nnode names; struct Tree *tree; }; 
typedef struct yyyT5 *yyyP5; 


struct yyyT6 {nnode names; }; 
typedef struct yyyT6 *yyyP6; 
                                                      /*custom*/  
typedef unsigned char yyyWAT; 
typedef unsigned char yyyRCT; 
typedef unsigned short yyyPNT; 
typedef unsigned char yyyWST; 

#include <limits.h>
#define yyyR UCHAR_MAX  

 /* funny type; as wide as the widest of yyyWAT,yyyWST,yyyRCT  */ 
typedef unsigned short yyyFT;

                                                      /*stock*/  




struct yyyGenNode {void *parent;  
                   struct yyyGenNode **cL; /* child list */ 
                   yyyRCT *refCountList; 
                   yyyPNT prodNum;                      
                   yyyWST whichSym; /* which child of parent? */ 
                  }; 

typedef struct yyyGenNode yyyGNT; 



struct yyyTB {int isEmpty; 
              int typeNum; 
              int nAttrbs; 
              char *snBufPtr; 
              yyyWAT *startP,*stopP; 
             };  




extern struct yyyTB yyyTermBuffer; 
extern yyyWAT yyyLRCIL[]; 
extern void yyyGenLeaf(); 

