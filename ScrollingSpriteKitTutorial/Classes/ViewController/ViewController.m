//
//  ViewController.m
//  ScrollingSpriteKitTutorial
//
//  Created by Arthur Knopper on 13-03-14.
//  Copyright (c) 2014 Arthur Knopper. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "FourthScene.h"
#import "ThirdScene.h"
#import "SecondScene.h"

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor redColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"clouds@2x.jpg"]];
}

- (void)viewWillLayoutSubviews {

    [super viewWillLayoutSubviews];
        // Configure the view.

}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)shouldAutorotate {

    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction)quitBtnTapped:(id)sender {

    exit(0);
}

#pragma mark - Character btn tapped

- (IBAction)characterBtnTapped:(id)sender {

    [self hideBtn:YES];

    vwCharacter = [[UIView alloc]initWithFrame:self.view.frame ];
    vwCharacter.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"clouds@2x.jpg"]];
    [self.view addSubview:vwCharacter];

    UIImageView *imgVwCharacter = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 250)/2, 40, 250, 50)];
    imgVwCharacter.contentMode = UIViewContentModeScaleAspectFill;
    imgVwCharacter.image  = [UIImage imageNamed:@"Character"];
    [vwCharacter addSubview:imgVwCharacter];

    UIButton *btnTom = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTom setTitle:@"Tom" forState:UIControlStateNormal];
    btnTom.titleLabel.font = [UIFont fontWithName:@"Zapfino" size:17];
    [btnTom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTom.frame = CGRectMake(120, self.view.frame.size.height - 40, 60, 44);
    [btnTom addTarget:self action:@selector(heroBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [vwCharacter addSubview:btnTom];

    UIButton *btnTomImg = [UIButton buttonWithType:UIButtonTypeCustom];//
    btnTomImg.frame = CGRectMake(160, self.view.frame.size.height - 70, 70, 80);
    [btnTomImg setImage:[UIImage imageNamed:@"ishira"] forState:UIControlStateNormal];
    btnTomImg.tag = 100;
    [btnTomImg addTarget:self action:@selector(heroBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [vwCharacter addSubview:btnTomImg];

    UIButton *btnIshira = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnIshira setTitle:@"Ishira" forState:UIControlStateNormal];
    btnIshira.titleLabel.font = [UIFont fontWithName:@"Zapfino" size:17];
    btnIshira.frame = CGRectMake(self.view.frame.size.width - 140, self.view.frame.size.height - 40, 75, 44);
    [btnIshira setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //imgVwTom.tag = 101;
    [btnIshira addTarget:self action:@selector(heroBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [vwCharacter addSubview:btnIshira];

    UIButton *btnIshiraImg = [UIButton buttonWithType:UIButtonTypeCustom];
    btnIshiraImg.frame = CGRectMake(self.view.frame.size.width - 80, self.view.frame.size.height - 70, 50, 80);
    [btnIshiraImg setImage:[UIImage imageNamed:@"ishira"] forState:UIControlStateNormal];
    [btnIshiraImg addTarget:self action:@selector(heroBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [vwCharacter addSubview:btnIshiraImg];
}

- (void)heroBtnTapped {

    [vwCharacter removeFromSuperview];
    [self hideBtn:NO];
}

- (IBAction)outfitBtnTapped:(id)sender{

    [self hideBtn:YES];
    [self outFitOfHero];
}

- (void)outFitOfHero {

    [self hideBtn:YES];

    vwCharacter = [[UIView alloc]initWithFrame:self.view.frame ];
    vwCharacter.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gr@2x.png"]];
    [self.view addSubview:vwCharacter];

    UILabel *lblOutFit = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 150)/2, 20, 150, 50)];
    lblOutFit.font = [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:35];
    lblOutFit.textAlignment = NSTextAlignmentCenter;
    lblOutFit.textColor = [UIColor blackColor];
    lblOutFit.text = @"Outfit";
    [vwCharacter addSubview:lblOutFit];

    UIButton *btnOutfit1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOutfit1 setTitle:@"Outfit1" forState:UIControlStateNormal];
    [btnOutfit1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOutfit1.frame = CGRectMake(120, self.view.frame.size.height - 100, 55, 44);
    [btnOutfit1 setBackgroundColor:[UIColor blackColor]];
    btnOutfit1.layer.borderColor = [[UIColor whiteColor]CGColor];
    [btnOutfit1 addTarget:self action:@selector(heroBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    btnOutfit1.layer.borderWidth = 2.0;
    [vwCharacter addSubview:btnOutfit1];

    UIImageView *imgVwTom = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ishira"]];
    imgVwTom.frame = CGRectMake(190, self.view.frame.size.height - 115, 50, 80);
    imgVwTom.tag = 100;
    [vwCharacter addSubview:imgVwTom];

    UIButton *btnOutfit2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOutfit2 setTitle:@"Outfit2" forState:UIControlStateNormal];
    btnOutfit2.frame = CGRectMake(self.view.frame.size.width - 140, self.view.frame.size.height - 100, 55, 44);
    [btnOutfit2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOutfit2.layer.borderColor = [[UIColor whiteColor]CGColor];
    btnOutfit2.layer.borderWidth = 2.0;
    imgVwTom.tag = 101;
    [btnOutfit2 addTarget:self action:@selector(heroBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    [btnOutfit2 setBackgroundColor:[UIColor blackColor]];
    [vwCharacter addSubview:btnOutfit2];

    UIImageView *imgVwIshira = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ishira"]];
    imgVwIshira.frame = CGRectMake(self.view.frame.size.width - 70, self.view.frame.size.height - 115, 50, 80);
    [vwCharacter addSubview:imgVwIshira];
}

- (IBAction)settingBtnTapped:(id)sender{

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vwController = [storyBoard instantiateViewControllerWithIdentifier:@"Settings"];
    [self.navigationController pushViewController:vwController animated:YES];
}

- (IBAction)playBtnTapped:(id)sender{

        // Configure the view.
    [imgVwBg removeFromSuperview];
    [btnCharacter removeFromSuperview];
    [btnSetting removeFromSuperview];
    [btnPlay removeFromSuperview];
    [btnQuit removeFromSuperview];

    [self hideBtn:YES];

    SKView * skView = (SKView *)self.view;
    
    if (!skView.scene) {

        skView.showsFPS = YES;
        skView.showsNodeCount = YES;

        // Create and configure the scene.
        SKScene * scene = [[MyScene alloc] initWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;

        // Present the scene.
        SKTransition *transition = [SKTransition doorsOpenVerticalWithDuration:0.2];
        [skView presentScene:scene transition:transition];
    }
}

- (void)hideBtn:(BOOL)isHide {

    [btnCharacter setHidden:isHide];
    [btnQuit setHidden:isHide];
    [btnPlay setHidden:isHide];
    [btnSetting setHidden:isHide];
}

@end
