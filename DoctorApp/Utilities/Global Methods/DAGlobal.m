//
//  DAGlobal.m
//  DoctorApp
//
//  Created by MacPro on 24/04/17.
//  Copyright © 2017 MacPro. All rights reserved.
//

#import "DAGlobal.h"

@implementation DAGlobal

+(NSMutableArray *)checkNullArray:(NSMutableArray *)inputArray
{
    if (inputArray == NULL)
    {
        NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
        return arr;
    }
    else{
        return inputArray;
    }
}
@end
