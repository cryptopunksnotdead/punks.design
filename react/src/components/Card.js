import React from 'react';


// todo:
//   move some styles e.g. position, width, height,etc. inline!!

export default class Card extends React.Component {

  constructor( props ) {
    super( props );
  }

  get backText() { return {
    "A": "?",
    "B": "="
  }};


  get frontTextA() { return {
     1: "1×1",
     2: "2×2",
     3: "3×3",
     4: "4×4",
     5: "5×5",
     6: "6x6",
     7: "7x7",
     8: "8x8"
  }};

 get frontTextB() { return {
     1: "1",
     2: "4",
     3: "9",
     4: "16",
     5: "25",
     6: "36",
     7: "49",
     8: "56"
  }};


  render() {

    const isA        = this.props.group == 'A';
    const isFlipped  = this.props.flipped;
    const isMatched  = this.props.matched;

    const frontTextA = this.frontTextA[this.props.num];
    const frontTextB = this.frontTextB[this.props.num];
    const backText   = this.backText[this.props.group];

    const cardClasses =
            "card" + (isFlipped ? " flipped" : "")
                   + (isMatched ? " matched" : "");

    const cardFrontClasses =
            `card-front card-front${this.props.num}`;     // add card-front1, card-front2, etc colors or something

    return(
  <div className={cardClasses} onClick={this.props.onClick}>
     <div className="card-back">{backText}</div>
          { isA ? (
                   <div className={cardFrontClasses}>{frontTextA}</div>
                  ) : (
                    <div className={cardFrontClasses}>
                       <div>{frontTextB}</div>
                       <div className="hint">{frontTextA}</div>
                    </div>
                  ) }
   </div>
  );
 }
}
