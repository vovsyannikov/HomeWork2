//
//  OldViewController.m
//  HomeWork2
//
//  Created by Виталий Овсянников on 29.10.2020.
//

#import "OldViewController.h"

@interface OldViewController ()

@property (weak, nonatomic) IBOutlet UILabel *wordsLabel;
@property (weak, nonatomic) IBOutlet UITextField *adderTextField;


@property (weak, nonatomic) IBOutlet UITextField *powerTextField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation OldViewController

NSString *words = @"";

- (IBAction)add:(id)sender {
    if (![_adderTextField.text isEqual: @""]) {
        if ([words isEqual: @""]) {
            words = _adderTextField.text;
        } else {
            words = [words stringByAppendingFormat: @" %@", _adderTextField.text];
        }
        _wordsLabel.text = words;
    }
    [_adderTextField setText: @""];
}

- (IBAction)powerUp:(id)sender {
    if (![_powerTextField.text isEqual: @""]){
        int twoPowered = 1;
        int power = [_powerTextField.text intValue];
        for (int i = 0; i < power; i++){
            twoPowered *= 2;
        }
        [_resultLabel setFont: [_resultLabel.font fontWithSize: 50] ];
        [_resultLabel setTextColor: [UIColor blackColor]];
        [_resultLabel setText: [[NSString alloc] initWithFormat: @"= %d\n", twoPowered]];
    } else {
        [_resultLabel setFont: [_resultLabel.font fontWithSize: 20]];
        [_resultLabel setTextColor: [UIColor redColor]];
        [_resultLabel setText: @"Введите целое число"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _wordsLabel.text = @"Введите слова ниже";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
