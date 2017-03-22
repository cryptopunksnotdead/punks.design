import React from 'react';


// todo:
//   move some styles e.g. position, width, height,etc. inline!!

export default class Card extends React.Component {
  constructor( props ) {
    super( props );
    this.state = { isFlipped: false };
  }

  handleClick(ev) {
    console.log( "click, click" );
    this.setState({
        isFlipped: !this.state.isFlipped
      });
  }

  render() {
    return (
  <div className={"card " + (this.state.isFlipped ? 'flipped' : '')}
       onClick={(e)=>this.handleClick(e)}>
     <div className="card-back">?</div>
     <div className="card-front">1×1</div>
  </div>
  )
 }
}
