import React from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  Button,
  Image,
} from 'react-native';
import {
  TabNavigator,
  DrawerNavigator
} from 'react-navigation';

AppRegistry.registerComponent('DemoProject', () => RootPage);
export default class RootPage extends React.Component {
  render() {
    return <MyApp />;
  }
}


class MyHomeScreen extends React.Component {
  static navigationOptions = {
    drawerLabel: 'Home',
    drawerIcon: ({
      tintColor
    }) => (
      <Image
        source={require('./imgs/01.png')}
        style={[styles.icon, {tintColor: tintColor}]}
      />
    ),
  };

  render() {
    return (
      <View style={styles.container}>
      <Text>This HomePage</Text>
      <Button
        onPress={() => this.props.navigation.navigate('DrawerOpen')}
        title="Show Drawer"
      />
      </View>
    );
  }
}

class MyNotificationsScreen extends React.Component {
  static navigationOptions = {
    drawerLabel: 'Notifications',
    drawerIcon: ({
      tintColor
    }) => (
      <Image
        source={require('./imgs/02.png')}
        style={[styles.icon, {tintColor: tintColor}]}
      />
    ),
  };

  render() {
    return (
      <View style={styles.container}>
      <Text>This MyNotificationsScreen</Text>
      <Button
        onPress={() => this.props.navigation.navigate('DrawerOpen')}
        title="Go back home"
      />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  icon: {
    width: 24,
    height: 24,
  },
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
});

const MyApp = DrawerNavigator({
  Home: {
    screen: MyHomeScreen,
  },
  Notifications: {
    screen: MyNotificationsScreen,
  },
});